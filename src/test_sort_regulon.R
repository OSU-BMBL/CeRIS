
########## Sort regulon by regulon specificity score ##################
# used files:
# filtered exp matrix
# cell label
# regulon_gene_symbol, regulon_gene_id, regulon_motif, motif_ranks (from merge_bbc.R)

library(scales)
library(sgof)
library(ggplot2)

args <- commandArgs(TRUE)
wd <- args[1] # filtered expression file name
jobid <- args[2] # user job id
#wd<-getwd()
####test
wd <- "D:/Users/flyku/Documents/IRIS3-data/20190818190915"
jobid <-20190818190915 
expFile <- "20190818190915_filtered_expression.txt"
labelFile <- "20190818190915_cell_label.txt"
# wd <- getwd()
setwd(wd)

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


#num_ct <- 1
#genes <- c("ANAPC11","APLP2","ATP6V1C2","DHCR7","GSPT1","HDGF","HMGA1")
#calculate regulon activity score (RAS) 
#expr <- as.matrix(exp_data)
# genes <- gene_name_list
calc_ras <- function(expr=NULL, genes,method=c("aucell","zscore","plage","ssgsea")) {
  if (method=="aucell"){ #use top 10% cutoff
    require(AUCell)
    names(genes) <- 1:length(genes)
    cells_rankings <- AUCell_buildRankings(exp_data,plotStats = F) 
    cells_AUC <- AUCell_calcAUC(genes, cells_rankings, aucMaxRank=nrow(cells_rankings)*0.1)
    score_vec <- cells_AUC@assays@data@listData[['AUC']]
  } else if (method=="zscore"){
    require("GSVA")
    score_vec <- gsva(expr,gset=genes,method="zscore")
  } else if (method=="plage"){
    require("GSVA")
    score_vec <- gsva(expr,gset=genes,method="plage")
  } else if (method=="ssgsea"){
    require("GSVA")
    score_vec <- gsva(expr,gset=genes,method="ssgsea")
  } 
  else if (method=="gsva"){
    require("GSVA")
    require("snow")
    score_vec <- gsva(expr,gset=genes,method="gsva",kcdf="Gaussian",abs.ranking=F,verbose=T,parallel.sz=8)
  } 
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

# test if difference in ras among two groups (whether in this cell type), FDR=0.05(default) used by Benjamini-Hochberg procedure
#score_vec <- ras
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
score_vec<-ras
# calculate regulon specificity score (RSS), based on regulon activity score and cell type specific infor,
calc_rss <- function (label_data=NULL,score_vec=NULL, num_ct=1){

  ct_vec <- ifelse(label_data[,2] %in% num_ct, 1, 0)
  # also normalize ct_vec to sum=1
  sum_ct_vec <- sum(ct_vec)
  ct_vec <- ct_vec/sum_ct_vec
  #calculate regulon specificity score (RSS); which defined by converting JSD to a similarity score
  rss <- 1- sqrt(jsd_result)

  ct_vec_repressed <- ifelse(label_data[,2] %in% num_ct, 0, 1)
  sum_ct_vec_repressed <- sum(ct_vec_repressed)
  ct_vec_repressed <- ct_vec_repressed/sum_ct_vec_repressed
  jsd_result_repressed <- apply(as.data.frame(score_vec), 1, function(x){
    return (calc_jsd(x,ct_vec_repressed))
  })
  #calculate regulon specificity score (RSS); which defined by converting JSD to a similarity score
  rss_repressed <- 1- sqrt(jsd_result_repressed)
  jsd_result <- apply(as.data.frame(score_vec), 1, function(x){
    return (min(calc_jsd(x,ct_vec),calc_jsd(x,ct_vec_repressed)))
  })
  rss <- 1- sqrt(jsd_result)
  return(rss)
}


sort_dir <- function(dir) {
  tmp <- sort(dir)
  split <- strsplit(tmp, "_CT_") 
  split <- as.numeric(sapply(split, function(x) x <- sub("_bic.*", "", x[2])))
  return(tmp[order(split)])
  
}

alldir <- list.dirs(path = wd)
alldir <- grep("*_bic$",alldir,value=T)
alldir <- sort_dir(alldir)

exp_data<- read.delim(paste(jobid,"_filtered_expression.txt",sep = ""),check.names = FALSE, header=TRUE,row.names = 1)
exp_data <- as.matrix(exp_data)

label_data <- read.table(paste(jobid,"_cell_label.txt",sep = ""),sep="\t",header = T)
marker_data <- read.table("cell_type_unique_marker.txt",sep="\t",header = T)
total_motif_list <- vector()
total_gene_list <- vector()
total_gene_index <- 1
#i=1
## to speed up gsva process, read all genes  to one list
length(alldir)
for (i in 1:1) {
  regulon_gene_name_handle <- file(paste(jobid,"_CT_",i,"_bic.regulon_gene_symbol.txt",sep = ""),"r")
  regulon_gene_name <- readLines(regulon_gene_name_handle)
  close(regulon_gene_name_handle)
  total_gene_list <- append(total_gene_list,regulon_gene_name)
}
total_gene_list<- lapply(strsplit(total_gene_list,"\\t"), function(x){x[-1]})
total_ras <- calc_ras(expr = exp_data,genes=total_gene_list,method = "gsva")
library(dabestr)
reg=1
ct=1
activity_score <- read.table(paste(jobid,"_CT_",ct,"_bic.regulon_activity_score.txt",sep = ""),row.names = 1,header = T,check.names = F)
barplot(as.matrix(activity_score[1,]))

barplot(originak_ras[1,])
barplot(as.matrix(ras[1,]))
barplot(as.matrix(ras[1,]))


  label_data <- label_data[order(label_data[,2]),]
  ct_vec <- ifelse(label_data[,2] %in% ct, "this_cell_type", "others")
  total_ras <- normalize_ras(total_ras)
  ras <- total_ras[1,]
  ras <- normalize_ras(ras)
  #rss <- calc_rss(label_data=label_data,score_vec = ras,num_ct = ct)
  df <- as.data.frame(cbind(as.numeric(ras),ct_vec))
  df[,1] <- as.numeric(df[,1])
  colnames(df) <- c("value","group")
  unpaired_mean_diff <- dabest(df,group, value,
                               idx =  c("this_cell_type","others"),
                               paired = F,ci=95)
  
  plot(unpaired_mean_diff)
  
  # get cell type vector, add 1 if in this cell type
  ct_vec_rss <- ifelse(label_data[,2] %in% ct, 0, 1)
  
  # also normalize ct_vec to sum=1
  sum_ct_vec <- sum(ct_vec_rss)
  ct_vec_rss <- ct_vec_rss/sum_ct_vec
  jsd_result <- apply(as.data.frame(ras), 1, function(x){
    return (calc_jsd(x,ct_vec_rss))
  })
  #calculate regulon specificity score (RSS); which defined by converting JSD to a similarity score
  rss <- 1- sqrt(jsd_result)


  ggplot_ras <- data.frame('score'=t(ras))
  ggplot_ras[,2] <- label_data[,1]
  ggplot_ras[,3] <- ifelse(label_data[,2] %in% ct, "this_cell_type", "others")
  ggplot_ras[,4] <- ct_vec_rss
  ggplot(ggplot_ras, aes(y=X1, x=V2, fill=ct_vec)) + 
    geom_bar( stat="identity")+ theme(axis.text.x = element_text(angle = 45, hjust = 1, size=12,color="#666666"),axis.title.y = element_text(size=14,color="#666666"),strip.text.x = element_text(size=16)) +
    labs(y="Regulon activity score",x="") +
    theme(legend.title=element_blank())+
    theme(plot.margin = unit(c(1,1,1,2), "cm"))
  
  ggplot(ggplot_ras, aes(y=V4, x=V2, fill=ct_vec)) + 
    geom_bar( stat="identity")+ theme(axis.text.x = element_text(angle = 45, hjust = 1, size=12,color="#666666"),axis.title.y = element_text(size=14,color="#666666"),strip.text.x = element_text(size=16)) +
    labs(y="Cell type",x="") +
    theme(legend.title=element_blank())+
    theme(plot.margin = unit(c(1,1,1,2), "cm"))
  

  
  ## check rss distribution
  ras <- total_ras
  ras <- normalize_ras(ras)
  for (i in nrow(ras)) {
    rss_list <- calc_rss(label_data=label_data,score_vec = ras,num_ct = 1)
  }
  
  
  