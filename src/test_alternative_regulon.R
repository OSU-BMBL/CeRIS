
########## Test alternative regulon ##################


library(scales)
library(sgof)
library(ggplot2)
library(dabestr)
require(xml2)
require(XML)
library(seqinr)
registerDoParallel(16) 
#args <- commandArgs(TRUE)
#wd <- args[1] # filtered expression file name
#jobid <- args[2] # user job id
#wd<-getwd()
####test
jobid <-20190907182105 

wd <- paste("/var/www/html/iris3/data/",jobid,sep="")
#wd <- paste("C:/Users/wan268/Documents/iris3_data/",jobid,sep="")
expFile <- paste(jobid,"_filtered_expression.txt",sep="")
labelFile <- paste(jobid,"_cell_label.txt",sep = "")
# wd <- getwd()
setwd(wd)
total_ct_number <- max(na.omit(as.numeric(stringr::str_match(list.files(path = wd), "_CT_(.*?)_bic")[,2])))



quiet <- function(x) { 
  sink(tempfile()) 
  on.exit(sink()) 
  invisible(force(x)) 
} 


# calculate Jensen-Shannon Divergence (JSD), used to calculate regulon specificity score (RSS)
calc_jsd <- function(v1,v2) {
  H <- function(v) {
    v <- v[v > 0]
    return(sum(-1 * v * log(v)))
  }
  return (H(v1/2+v2/2) - (H(v1)+H(v2))/2)
}


calc_ranking <- function(expr){
  require(data.table)
  if(!data.table::is.data.table(expr))
    expr <- data.table::data.table(expr, keep.rownames=TRUE)
  data.table::setkey(expr, "rn") # (reorders rows)
  colsNam <- colnames(expr)[-1] # 1=row names
  #names(genes) <- 1:length(genes)
  rankings <- expr[, (colsNam):=lapply(-.SD, data.table::frankv,order=-1L, ties.method="random", na.last="keep"),
                   .SDcols=colsNam]
  rn <- rankings$rn
  rankings <- as.matrix(rankings[,-1])
  rownames(rankings) <- rn
  return(rankings)
}


#num_ct <- 1
#genes <- c("ANAPC11","APLP2","ATP6V1C2","DHCR7","GSPT1","HDGF","HMGA1")
#calculate regulon activity score (RAS) 
# expr <- exp_data
# genes <- total_gene_list
calc_ras <- function(expr=NULL, genes,method=c("aucell","zscore","plage","ssgsea","custom_auc"), rankings) {
  print(Sys.time())
  if (method=="aucell"){ #use top 10% cutoff
    require(AUCell)
    expr <- as.matrix(expr)
    names(genes) <- 1:length(genes)
    cells_rankings <- AUCell_buildRankings(expr,plotStats = F) 
    cells_AUC <- AUCell_calcAUC(genes, cells_rankings, aucMaxRank=nrow(cells_rankings)*0.1)
    #score_vec <- cells_AUC@assays@data@listData[['AUC']]
    #score_vec <- cells_AUC@assays@.xData$data$AUC
    ## AUCell modified object structure
    tryCatch(score_vec <- cells_AUC@assays@data@listData[['AUC']],error = function(e) score_vec <- cells_AUC@assays@.xData$data$AUC)
    
  } else if (method=="zscore"){
    require("GSVA")
    score_vec <- gsva(expr,gset=genes,method="zscore")
  } else if (method=="plage"){
    require("GSVA")
    score_vec <- gsva(expr,gset=genes,method="plage")
  } else if (method=="ssgsea"){
    require("GSVA")
    score_vec <- gsva(expr,gset=genes,method="ssgsea")
  } else if (method=="gsva"){
    require("GSVA")
    require("snow")
    score_vec <- gsva(expr,gset=genes,method="gsva",kcdf="Gaussian",abs.ranking=F,verbose=T,parallel.sz=8)
  } else if (method=="wmw_test"){
    require(BioQC)
    require(data.table)
    geneset <- as.data.frame(lapply(genes, function(x){
      return(rownames(rankings) %in% x)
    }))
    names(geneset) <- 1:ncol(geneset)
    dim(geneset)
    score_vec <- wmwTest(rankings, geneset, valType="abs.log10p.greater", simplify = T)
    
    #score_vec[score_vec < 1] <- 0
    #for (i in 1:nrow(score_vec)) {
    #  tmp <- as.numeric(quantile(score_vec[i,])[2])
    #  #tmp2 <- mean(score_vec[i,])
    #  #tmp3 <- median(score_vec[i,])
    #  #snr1 <- mean(score_vec[i,])/sd(score_vec[i,])
    #  score_vec[i,which(as.numeric(score_vec[i,]) < tmp)] <- 0
    #  #c1 <- pass.filt(score_vec[i,], W=0.05, type="stop", method="ChebyshevI")
    #  #barplot(score_vec[i,])
    #  #barplot(c1)
    #}
    
    #barplot(score_vec1[1,])
    ##### test two u-test function speed
    #library(microbenchmark)
    #microbenchmark(
    #  sapply(indx, function(i) wmwTest(rankings[,i], set_in_list, valType="p.two.sided")),times = 10
    #)
    #microbenchmark(
    #  sapply(indx, function(i) wilcox.test(gSetRanks[,i], other_ranking[,i])$p.value),times = 10
    #)
    #
  }
  print(Sys.time())
  return(score_vec)
}


#normalization
normalize_ras <- function(score_vec){
  #normalize score_vec(regulon activity score) to range(0,1) and sum=1
  score_vec <- apply(score_vec, 1, rescale)
  score_vec <- t(score_vec)
  score_vec <- as.data.frame(t(apply(data.frame(score_vec), 1, function(x){
    x <- x/sum(x)
  })))
  return(score_vec)
}

# [Deprecated].test if difference in ras among two groups (whether in this cell type), FDR=0.05(default) used by Benjamini-Hochberg procedure
calc_ras_pval <- function(label_data=NULL,score_vec=NULL, num_ct=1){
  # get cell type vector, add 1 if in this cell type
  ct_vec <- ifelse(label_data[,2] %in% num_ct, 1, 0)
  group1 <- score_vec[,which(ct_vec==1)]
  group0 <- score_vec[,which(ct_vec==0)]
  
  ## two sample t-test
  #pval <- apply(data.frame(1:nrow(group1)),1, function(x){
  #  return (t.test(group1[x,],group0[x,])$p.value)
  #})
  
  ## wilcox rank sum test
  pval <- apply(data.frame(1:nrow(group1)),1, function(x){
    return (wilcox.test(as.numeric(group1[x,]),as.numeric(group0[x,]))$p.value)
  })
  ##Benjamini-Hochberg procedure
  pval_correction <- sgof::BH(pval)
  adj_pval <-pval_correction$Adjusted.pvalues[order(match(pval_correction$data,pval))]
  return(adj_pval)
  
  ## plots for test 
  #new_regulon_filter_by_fdr <- !which(adj_pval>0.05) %in% which(pval>0.05)
  #if (isTRUE(any(new_regulon_filter_by_fdr))){
  #  s1<-score_vec[which(result_pvalue>0.05)[!which(result_pvalue>0.05) %in% which(r1>0.05)],]
  #  for (i in 1:16) {
  #    barplot(as.matrix(s1[i,]))
  #  }
  #} else {
  #  pval_order <- order(adj_pval)
  #  
  #  s2 <- score_vec[pval_order,]
  #  for (i in 1:16) {
  #    barplot(as.matrix(s2[i,]))
  #  }
  #}
}

calc_rss_pvalue <- function(this_rss=0.66,this_bootstrap_rss,ct=1){
  #ef <- ecdf(this_bootstrap_rss)
  #pvalue <- 1 - ef(this_rss)
  pvalue <- length(which(this_rss < this_bootstrap_rss))/length(this_bootstrap_rss)
  return(pvalue)
}

# calculate regulon specificity score (RSS), based on regulon activity score and cell type specific infor,
calc_rss <- function (label_data=NULL,score_vec=NULL, num_ct=1){
  
  # get cell type vector, add 1 if in this cell type
  ct_vec <- ifelse(label_data[,2] %in% num_ct, 1, 0)
  
  # also normalize ct_vec to sum=1
  sum_ct_vec <- sum(ct_vec)
  ct_vec <- ct_vec/sum_ct_vec
  jsd_result <- apply(as.data.frame(score_vec), 1, function(x){
    return (calc_jsd(x,ct_vec))
  })
  #calculate regulon specificity score (RSS); which defined by converting JSD to a similarity score
  rss <- 1- sqrt(jsd_result)
  return(rss)
}

calc_bootstrap_ras <- function(rankings,iteration=100,regulon_size=45){
  random_genes <- as.data.frame(replicate(iteration, sample.int(nrow(rankings), regulon_size)))
  boot_vec <- wmwTest(rankings, random_genes, valType="abs.log10p.greater", simplify = T)
  #random_genes <- replicate(iteration, list(rownames(rankings)[sample.int(nrow(rankings), regulon_size)]))
  #boot_vec <- gsva(exp_data,gset=random_genes,method="zscore")
  return(boot_vec)
}


calc_bootstrap_rss <- function(boot_ras,ct){
  boot_ras <- normalize_ras(boot_ras)
  this_rss <- as.numeric(calc_rss(label_data=label_data,score_vec = boot_ras,num_ct = ct))
  return(this_rss)
}


sort_dir <- function(dir) {
  tmp <- sort(dir)
  split <- strsplit(tmp, "_CT_") 
  split <- as.numeric(sapply(split, function(x) x <- sub("_bic.*", "", x[2])))
  return(tmp[order(split)])
  
}

#alldir <- list.dirs(path = wd)
#alldir <- grep("*_bic$",alldir,value=T)
#alldir <- sort_dir(alldir)
#
#exp_data<- read.delim(paste(jobid,"_filtered_expression.txt",sep = ""),check.names = FALSE, header=TRUE,row.names = 1)
#exp_data <- as.matrix(exp_data)

#label_data <- read.table(paste(jobid,"_cell_label.txt",sep = ""),sep="\t",header = T)
#marker_data <- read.table("cell_type_unique_marker.txt",sep="\t",header = T)
total_motif_list <- vector()
total_gene_list <- vector()
total_rank <- vector()
total_gene_index <- 1
#i=1
## to speed up gsva process, read all genes  to one list

for (i in 1:total_ct_number) {
  regulon_gene_name_handle <- file(paste(jobid,"_CT_",i,"_bic.regulon_gene_symbol.txt",sep = ""),"r")
  regulon_gene_name <- readLines(regulon_gene_name_handle)
  close(regulon_gene_name_handle)
  
  regulon_rank_handle <- file(paste(jobid,"_CT_",i,"_bic.regulon_rank.txt",sep = ""),"r")
  regulon_rank <- readLines(regulon_rank_handle)
  close(regulon_rank_handle)
  
  regulon_motif_handle <- file(paste(jobid,"_CT_",i,"_bic.regulon_motif.txt",sep = ""),"r")
  regulon_motif <- readLines(regulon_motif_handle)
  close(regulon_motif_handle)
  
  total_gene_list <- append(total_gene_list,regulon_gene_name)
  total_motif_list <- append(total_motif_list,regulon_motif)
  total_rank <- append(total_rank,regulon_rank)
}

t1 <- "CT4S-R122"
#length(grep("CT3.*?",t1))
#length(grep("CT4.*?",t1))
total_gene_list<- lapply(strsplit(total_gene_list,"\\t"), function(x){x[-1]})
total_motif_list<- lapply(strsplit(total_motif_list,"\\t"), function(x){x[-1]})
total_rank<- strsplit(total_rank,"\\t")
total_rank_df <- vector()

for (i in 1:length(total_rank)) {
  this_ct <- strsplit(strsplit(total_rank[[i]][1],"CT")[[1]][2],"S")[[1]][1]
  total_rank_df <- rbind(total_rank_df,c(total_rank[[i]][c(1,5,6)],this_ct))
  colnames(total_rank_df) <- c("regulon_id","rss_pval","rss","cell_type")
}


alldir <- list.dirs(path = wd)
alldir <- grep("*_bic$",alldir,value=T)
alldir <- sort_dir(alldir)
short_dir <- grep("*_bic$",list.dirs(path = wd,full.names = F),value=T) 
short_dir<- sort_dir(short_dir)
gene_id_name <- read.table(paste(jobid,"_gene_id_name.txt",sep=""))
#i=7;j=1;k=m=3
#
total_ct <- max(na.omit(as.numeric(stringr::str_match(list.files(path = wd), "_CT_(.*?)_bic")[,2])))

module_type <- sub(paste(".*",jobid,"_ *(.*?) *_.*",sep=""), "\\1", short_dir)
count_num_regulon<-0
regulon_idx_module <- 0
#xml_text(motif_name)
#i=260
allfiles <- list.files(path = "tomtom",pattern = "tomtom.xml",recursive = T,full.names = T)
total_motif_name <- data.frame()
for (i in 1:length(allfiles)) {
  motif_id <- strsplit(allfiles[i],"/")[[1]][2]
  xml_data <- read_xml(allfiles[i])
  tf_query <- xml_find_all(xml_data, ".//motif")
  tf_id <- xml_attr(tf_query, "id")
  tf_alt <- xml_attr(tf_query, "alt")
  tf_name <- as.character(mapply(function(x,y){
    if(is.na(y)){
      return(x)
    } else {
      return(y)
    }
  }, x=tf_id,y=tf_alt))
  motif_index <- xml_find_all(xml_data, ".//matches")
  motif_index <- xml_find_all(xml_data, ".//query")
  motif_index <- xml_find_all(xml_data, ".//target")
  motif_index <-as.numeric(xml_attr(motif_index, "idx")[1]) + 2
  if(!is.na(motif_index)){
    total_motif_name <- rbind(total_motif_name,data.frame(motif_id,tf_name[motif_index]))
  }
}
colnames(total_motif_name) <- c("motif_id","TF_name")

total_motif_name[,2] <- gsub("[_(].*","",total_motif_name[,2])

total_tf_list <- list()
for (i in 1:length(unique(total_motif_name[,2]))) {
  this_tf_index <- total_motif_name[,2] %in% unique(total_motif_name[,2])[i]
  tmp_list <- c(as.character(unique(total_motif_name[,2])[i]),as.character(total_motif_name[this_tf_index,1]))
  total_tf_list <- append(list(tmp_list),total_tf_list)
}

regulon_tf_name <- lapply(total_motif_list, function (x){
  motif <- x[1]
  str <- strsplit(motif,",")[[1]]
  t1 <- paste("ct",str[1],"bic",str[2],"m",str[3],sep="")
  t2 <- lapply(total_tf_list, match,t1)
  t2 <- which(lapply(t2, function(x) x[!is.na(x)]) == 1)
  return(total_tf_list[[t2]][1])
})

tf_name_regulon <- data.frame(tf=unlist(regulon_tf_name),idx=seq(1:length(regulon_tf_name)))
tf_name_regulon <- cbind(tf_name_regulon,total_rank_df)
#tf_name_regulon <- tf_name_regulon[,-2]

ct_seq=seq(1:total_ct)
select_idx <- paste("CT",ct_seq,"S-R",sep="")
select_idx_result<-vector()
#x=total_rank[[1]]
for (i in ct_seq) {
  num_regulons_in_this_ct <- length(which(unlist(lapply(total_rank,function(x){
    return(any(grepl(select_idx[i],x)))
  }))))
  tmp <- paste(select_idx[i],seq(1:num_regulons_in_this_ct),sep="")
  select_idx_result <- c(select_idx_result,tmp)
}

## run atac
#foreach (i=1:length(select_idx_result)) %dopar% {system(paste("/var/www/html/iris3/program/count_peak_overlap_single_file.sh", getwd(),select_idx_result[i], "Mouse",sep = " "))}

alternative_regulon_result <- vector()
for (i in 1:length(select_idx_result)) {
  tf_idx <- which(tf_name_regulon$regulon_id == select_idx_result[i])
  this_tf <- as.character(tf_name_regulon$tf[tf_idx])
  all_tf_idx <- which(tf_name_regulon$tf == this_tf)
  all_alternative_regulon <- tf_name_regulon[all_tf_idx,]
  for (j in 1:length(all_tf_idx)) {
    all_alternative_regulon[j,7] <- length(total_gene_list[[all_tf_idx[j]]])
    all_alternative_regulon[j,8] <- as.list(paste(total_gene_list[[all_tf_idx[j]]],",",collapse = "",sep = ""))
  }
  tmp_df <- data.frame(tf=rep(this_tf,total_ct),cell_type=seq(1:total_ct))
  tmp_result <- merge(tmp_df,all_alternative_regulon,by.x=2,by.y=6,all=T)
  alternative_regulon_result <- rbind(alternative_regulon_result,tmp_result)
}
alternative_regulon_result <- alternative_regulon_result[c(-3,-4)]
names(alternative_regulon_result)[6] <- "num_genes"
names(alternative_regulon_result)[7] <- "genes"
names(alternative_regulon_result)[2] <- "tf"
alternative_regulon_result <- alternative_regulon_result[!duplicated(alternative_regulon_result), ]

top_n_idx <- function(x, n=10) {
  nx <- length(x)
  p <- nx-n
  xp <- sort(x, partial=p)[p]
  rev(which(x > xp)[order(x[which(x > xp)])])
  
}

atac_result <- vector()
for (i in 1:length(select_idx_result)) {
  this_regulon <- select_idx_result[i]
  fn <- paste("atac/",select_idx_result[i],".atac_overlap_result.txt",sep = "")
  fn_handle <- file(fn,"r")
  fn_data <- readLines(fn_handle)
  close(fn_handle)
  fn_data <- strsplit(fn_data,"\\t")
  #x=fn_data[[1]]
  rank_value <- as.numeric(unlist(lapply(fn_data, function(x){
    return(length(strsplit(x[8]," ")[[1]]))
  })))
  this_atac_result <- vector()
  top_idx <- top_n_idx(rank_value)
  if (length(top_idx) > 0){
    for (j in 1:length(top_idx)) {
      this_data <- fn_data[[top_idx[j]]]
      tmp_result <- c(this_data[1],length(strsplit(this_data[8]," ")[[1]]))
      this_atac_result <- rbind(this_atac_result,tmp_result)
    }
    this_tissue <- paste(this_atac_result[,1],sep = "",collapse = ",")
    this_num_overlap_genes <- paste(this_atac_result[,2],sep = "",collapse = ",")
    tmp_df <- data.frame(regulon_id=this_regulon,atac_tissue=this_tissue,num_overlap_genes=this_num_overlap_genes)
  } else {
    tmp_df <- data.frame(regulon_id=this_regulon,atac_tissue=NA,num_overlap_genes=NA)
  }
  tmp_df <- as.list(tmp_df)
  atac_result <- rbind(atac_result,tmp_df)
}
atac_result <- as.data.frame(atac_result)
alternative_regulon_result <- merge(alternative_regulon_result,atac_result,by.x=3,by.y=1,all = T)
alternative_regulon_result <- alternative_regulon_result[c(1,2,3,4,5,6,8,9,7)]
alternative_regulon_result <- alternative_regulon_result[order(alternative_regulon_result$tf, alternative_regulon_result$cell_type),]
alternative_regulon_result <- apply(alternative_regulon_result, 2, as.character)
write.table(alternative_regulon_result,paste(jobid,"_alternative_regulon_result.txt",sep = ""),col.names = T,row.names = F,quote = F,sep = "\t")

#t1 <- read.table(paste(jobid,"_alternative_regulon_result.txt",sep = ""),sep = "\t",header = T)
#t1 <- t1[!duplicated(t1), ]
#write.table(t1,paste(jobid,"_alternative_regulon_result.txt",sep = ""),col.names = T,row.names = F,quote = F,sep = "\t")


#write.table(atac_result,paste(jobid,"_atac_result.txt",sep = ""),col.names = T,row.names = F,quote = F,sep = "\t")

