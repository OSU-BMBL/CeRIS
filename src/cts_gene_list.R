#Generate gene list by 
#1. raw expression file or jobid_filtered_expression.txt
#2. jobid_blocks.conds.txt
#3. jobid_blocks.gene.txt
#4. cell label
#output:
#1. jobid_gene_name.txt
#2. jobid_CT_ClusterIndex_bic.txt
library(tidyverse)
library(rlist)
args <- commandArgs(TRUE)
expFile <- args[1] # raw or filtered expression file name
jobid <- args[2] # user job id
label_file <- args[3] # sc3 or user label
getwd()
# setwd("D:/Users/flyku/Documents/IRIS3-data/test3")
# jobid <-2018122612831
# expFile <- "2018122612831_filtered_expression.txt"
# label_file <- "2018122612831_cell_label.txt"
#setwd("C:/Users/flyku/Desktop/iris3/data")

conds_file <- read.delim(paste(jobid,"_blocks.conds.txt",sep = ""),sep=" ",header = F)[,-1]
gene_file <- read.delim(paste(jobid,"_blocks.gene.txt",sep = ""),sep=" ",header = F)[,-1]
#conds_file <- read_delim(paste(jobid,"_blocks.conds.txt",sep = ""),delim=" ",col_names = F)[,-1]
#conds_file <- read_csv(paste(jobid,"_blocks.conds.txt",sep = ""),col_names = F)
#gene_file <- read_delim(paste(jobid,"_blocks.gene.txt",sep = ""),delim=" ",col_names = F)[,-1]
conds_file <- conds_file[!apply(conds_file == "", 1, all),]
#cell_label <- read_delim("iris3_example_expression_label.csv",delim=",",col_names = T)
cell_label <- read.table(label_file,sep="\t",header = T)
gene_expression <- read.table(expFile,sep="\t",header = T)
gene_name <- rownames(gene_expression)
write.table(gene_name,paste(jobid,"_gene_name.txt",sep = ""), sep="\t",row.names = F,col.names = F,quote = F)

#conds_label <- conds_file%>%
#  t()%>%
#  as.tibble()%>%
#  gather(id,conds,V1:ncol(.))%>%
#  drop_na()%>%
#  mutate(id=as.numeric(str_extract(id,"[0-9]+")))%>%
#  select(conds,id)
  
colnames(cell_label) <- c("cell","label")
count_cluster <- length(levels(as.factor(cell_label$label)))

#test
#df=conds_file[1,]
get_pvalue <- function(df){
  count_cluster <- length(levels(as.factor(cell_label$label)))
  tmp_pvalue <- 0
  result_pvalue <- vector()
  result <- list()
  for (i in 1:count_cluster) {
    A <- unlist(cell_label[which(cell_label$label==i),1])
    B <- unlist(df)
    m=length(A)
    n=nrow(cell_label)-m
    x=length(A[(A%in%B)])
    k=length(na.omit(unlist(df)))-1
    tmp_pvalue <- 1 - phyper(x,m,n,k)
    result_pvalue[i] <- tmp_pvalue
  }
  
  #min_pvalue <- min(result_pvalue)
  #min_i <- which(min_pvalue==result_pvalue)
  
  #return (list(pvalue=min_pvalue,cell_type=min_i))
  return (list(pvalue=result_pvalue,cell_type=seq(1:count_cluster)))
}

pv <- apply(conds_file,1,get_pvalue)



get_pvalue_df <- function(lis,num){
  result <- lis$pvalue
  ct <- lis$cell_type
  for (i in ct) {
    if(i == num){
      return(result[i])
    }
  }
}

#test get_bic_in_ct
#lis=pv[[2]]
#num=4
get_bic_in_ct <- function(lis,num){
  pval <- lis$pvalue
  result <- lis$cell_type
  for (i in result) {
    if(i == num && pval[i] <= pvalue_thres){
      return (pval[i])
    }
  }
}
total_bic <- 0
#i=1;j=3
for (j in 1:count_cluster) {
pvalue_thres <- 0.05
uniq_li <- sapply(pv, get_bic_in_ct,num=j)
#uniq_bic <- gene_file[which(uniq_li==1),]%>%
#  t%>%
#  as.vector()%>%
#  unique()%>%
#  write.table(.,paste(jobid,"_CT_",j,"_bic_unique.txt",sep = ""),sep="\t",row.names = F,col.names = F,quote = F)

names(uniq_li) <- seq_along(uniq_li) #preserve index of the non-null values
uniq_li <- compact(unlist(uniq_li))

uniq_bic <- gene_file[names(uniq_li),]%>%
  t%>%
  as.vector()%>%
  table()%>%
  as.data.frame()%>%
  write.table(.,paste(jobid,"_CT_",j,"_bic_unique.txt",sep = ""),sep="\t",row.names = F,col.names = F,quote = F)

pvalue_df <- unlist(sapply(pv, get_pvalue_df,num=j))
#pvalue_thres <- as.numeric(quantile(pvalue_df[pvalue_df <1], 0.05)) # 0.05 for 5% quantile )

li <- sapply(pv, get_bic_in_ct,num=j)
names(li) <- seq_along(li) #preserve index of the non-null values
li <- compact(unlist(li))
gene_bic <- gene_file[names(li),]%>%
  t%>%
  as.data.frame()

gene_bic[] <- lapply(gene_bic, as.character)
gene_bic <- data.frame(lapply(gene_bic, function(x) {gsub("_.", "", x)}))

if(length(gene_bic) > 0) {
colnames(gene_bic) <- paste0("bic",names(li))

gene_name <- read.table(paste(jobid,"_gene_name.txt",sep = ""),header = F,stringsAsFactors = F)


get_gene_name_overlap <- function(df){
  match <- gene_name$V1%in%as.character(df)
  return (match)
}

gene_overlap <- gene_name
for (i in 1:ncol(gene_bic)) {
  tmp_match <- gene_name$V1%in%as.character(gene_bic[,i])
  gene_overlap[,i+1] <- ifelse(tmp_match,1,0)
  
}
ncol(gene_overlap)
colnames(gene_overlap) <- c("geneid",colnames(gene_bic))
gene_overlap[,"weight"] <- rowSums(as.data.frame(gene_overlap[,-1]))
total_bic <- total_bic + ncol(gene_bic)
write.table(gene_bic,paste(jobid,"_CT_",j,"_bic.txt",sep = ""),sep="\t",row.names = F,col.names = T,na = "",quote = F)
#write.table(gene_overlap,paste("gene_overlap",j,".txt",sep = ""),row.names = F,col.names = T,quote = F)
}
}
write(paste("total_label,",nrow(cell_label),sep=""),file=paste(jobid,"_info.txt",sep=""),append=TRUE)
write(paste("total_bic,",total_bic,sep=""),file=paste(jobid,"_info.txt",sep=""),append=TRUE)