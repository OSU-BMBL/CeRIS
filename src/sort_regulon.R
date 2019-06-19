
########## Sort regulon by regulon specificity score ##################
# used files:
# filtered exp matrix
# cell label
# regulon_gene_name, regulon, regulon_motif

library(AUCell)

args <- commandArgs(TRUE)
wd <- args[1] # filtered expression file name
jobid <- args[2] # user job id

###test
# wd <- "D:/Users/flyku/Documents/IRIS3-data/test_combine"
# jobid <-20190617154456 
# expFile <- "20190617154456_filtered_expression.txt"
# labelFile <- "20190617154456_cell_label.txt"

setwd(wd)
# calculate Jensen-Shannon Divergence (JSD), used to calculate regulon specificity score (RSS)
calc_jsd <- function(v1,v2) {
  H <- function(v) {
    v <- v[v > 0]
    return(sum(-1 * v * log(v)))
  }
  return (H(v1/2+v2/2) - (H(v1)+H(v2))/2)
}

#num_ct <- 1
#genes <- c("ANAPC11","APLP2","ATP6V1C2","DHCR7","GSPT1","HDGF","HMGA1","SF1")
calc_regulon_score <- function (cells_rankings=cells_rankings,genes,num_ct){
  geneSets <- list(geneSet1=genes)
  cells_AUC <- AUCell_calcAUC(geneSets, cells_rankings, aucMaxRank=nrow(cells_rankings)*0.05)
  # get auc score vector
  auc_vec <- getAUC(cells_AUC)
  #normalize auc_vec to sum=1
  sum_auc_vec <- sum(auc_vec)
  auc_vec <- auc_vec/sum_auc_vec
  # get cell type vector, add 1 if in this cell type
  ct_vec <- ifelse(label_data[,2] %in% num_ct, 1, 0)
  # also normalize ct_vec to sum=1
  sum_ct_vec <- sum(ct_vec)
  ct_vec <- ct_vec/sum_ct_vec
  jsd_result <- calc_jsd(as.vector(auc_vec),ct_vec)
  #calculate regulon specificity score (RSS); which defined by converting JSD to a similarity score
  rss <- 1- sqrt(jsd_result)
  return(rss)
}
sort_dir <- function(dir) {
  tmp <- sort(dir)
  split <- strsplit(tmp, "_CT_") 
  split <- as.numeric(sapply(split, function(x) x <- sub("_bic.*", "", x[2])))
  return(tmp[order(split)])
  
}
workdir <- getwd()
alldir <- list.dirs(path = workdir)
alldir <- grep("*_bic$",alldir,value=T)
alldir <- sort_dir(alldir)


exp_data<- read.delim(paste(jobid,"_filtered_expression.txt",sep = ""),check.names = FALSE, header=TRUE,row.names = 1)
exp_data <- as.matrix(exp_data)
cells_rankings <- AUCell_buildRankings(exp_data) 

label_data <- read.table(paste(jobid,"_cell_label.txt",sep = ""),sep="\t",header = T)

#i=1
# genes=x= gene_name_list[[2]]
for (i in 1:length(alldir)) {
  
  regulon_gene_name_handle <- file(paste(jobid,"_CT_",i,"_bic.regulon_gene_name.txt",sep = ""),"r")
  regulon_gene_name <- readLines(regulon_gene_name_handle)
  close(regulon_gene_name_handle)
  
  regulon_gene_id_handle <- file(paste(jobid,"_CT_",i,"_bic.regulon.txt",sep = ""),"r")
  regulon_gene_id <- readLines(regulon_gene_id_handle)
  close(regulon_gene_id_handle)
  
  regulon_motif_handle <- file(paste(jobid,"_CT_",i,"_bic.regulon_motif.txt",sep = ""),"r")
  regulon_motif <- readLines(regulon_motif_handle)
  close(regulon_motif_handle)
  
  
  gene_name_list <- lapply(strsplit(regulon_gene_name,"\\t"), function(x){x[-1]})
  gene_id_list <- lapply(strsplit(regulon_gene_id,"\\t"), function(x){x[-1]})
  motif_list <- lapply(strsplit(regulon_motif,"\\t"), function(x){x[-1]})
  
  
  rss_list <- lapply(gene_name_list, function(x){
    calc_regulon_score(cells_rankings,x,i)
  })
  # calculate to be removed regulons index, if no auc score or less than 0.05
  rss_keep_index <- lapply(rss_list, function(x){
    if(is.na(x) || x < 0.05)
      return (1)
    else return(0)
  })
  rss_keep_index <- which(unlist(rss_keep_index) == 0)
  rss_list <- rss_list[rss_keep_index]
  gene_name_list <- gene_name_list[rss_keep_index]
  gene_id_list <- gene_id_list[rss_keep_index]
  motif_list <- motif_list[rss_keep_index]
  
  rss_rank <- rank(unlist(rss_list),ties.method = "first")
  gene_name_list <- gene_name_list[rss_rank]
  gene_id_list <- gene_id_list[rss_rank]
  motif_list <- motif_list[rss_rank]

  #j=1
  for (j in 1:length(gene_name_list)) {
    regulon_tag <- paste("CT",i,"S-R",j,sep = "")
    gene_name_list[[j]] <- append(regulon_tag,gene_name_list[[j]])
    gene_id_list[[j]] <- append(regulon_tag,gene_id_list[[j]])
    motif_list[[j]] <- append(regulon_tag,motif_list[[j]])
    rss_list[[j]] <- append(regulon_tag,rss_list[[j]])
  }
  #lapply(gene_name_list, function(x) write_file(data.frame(x), 'test_regulon_gene_name.txt',append= T))
  cat("",file=paste(jobid,"_CT_",i,"_bic.regulon_gene_name.txt",sep = ""))
  cat("",file=paste(jobid,"_CT_",i,"_bic.regulon.txt",sep = ""))
  cat("",file=paste(jobid,"_CT_",i,"_bic.regulon_motif.txt",sep = ""))
  cat("",file=paste(jobid,"_CT_",i,"_rss.txt",sep = ""))
  for (j in 1:length(gene_name_list)) {
    cat(gene_name_list[[j]],file=paste(jobid,"_CT_",i,"_bic.regulon_gene_name.txt",sep = ""),append = T,sep = "\t")
    cat("\n",file=paste(jobid,"_CT_",i,"_bic.regulon_gene_name.txt",sep = ""),append = T)
    
    cat(gene_id_list[[j]],file=paste(jobid,"_CT_",i,"_bic.regulon.txt",sep = ""),append = T,sep = "\t")
    cat("\n",file=paste(jobid,"_CT_",i,"_bic.regulon.txt",sep = ""),append = T)
    
    cat(motif_list[[j]],file=paste(jobid,"_CT_",i,"_bic.regulon_motif.txt",sep = ""),append = T,sep = "\t")
    cat("\n",file=paste(jobid,"_CT_",i,"_bic.regulon_motif.txt",sep = ""),append = T)
    
    cat(rss_list[[j]],file=paste(jobid,"_CT_",i,"_rss.txt",sep = ""),append = T,sep = "\t")
    cat("\n",file=paste(jobid,"_CT_",i,"_rss.txt",sep = ""),append = T)
  }
  
}

