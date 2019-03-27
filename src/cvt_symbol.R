#######  Convert gene name -> Ensembl gene id ##########
#######  Create a folder by filename, inside folder create each module by clusters  ##########

#if (!requireNamespace("BiocManager", quietly = TRUE))
#  install.packages("BiocManager")
#BiocManager::install("GenomicAlignments", version = "3.8")
#BiocManager::install("ensembldb", version = "3.8")
#BiocManager::install("EnsDb.Hsapiens.v86", version = "3.8")
#BiocManager::install("EnsDb.Mmusculus.v79", version = "3.8")
library(GenomicAlignments)
library(ensembldb)
library(EnsDb.Hsapiens.v86)
library(EnsDb.Mmusculus.v79)
#setwd("C:/Users/flyku/Desktop/iris3")
args <- commandArgs(TRUE)
srcDir <- args[1]
expName <- args[2]
setwd(srcDir)
getwd()
# setwd("/home/www/html/iris3/data/2019030481235")
# jobid <-2018122223516
#  srcDir <-  getwd()
#expName <- "2018122223516_filtered_expression.txt"
srcFile <- list.files(srcDir,pattern = "*_bic.txt")
expFile <- read.table(expName,sep="\t",header = T)

jobid <- gsub("_.*","",expName)
get_row_num <- function (this){
  num = 0
  for (i in 1:length(this)) {
    if(nchar(as.character(this[i]))>0){
      num = num +  1
    }
  }
  return (num)
}

check_species <- function(expFile) {
  result_human <- nrow(genes(EnsDb.Hsapiens.v86, filter=list(GeneNameFilter(rownames(expFile)),GeneIdFilter("ENSG", "startsWith")), 
                             return.type="data.frame", columns=c("gene_id")))
  result_mouse <- nrow(genes(EnsDb.Mmusculus.v79, filter=list(GeneNameFilter(rownames(expFile)),GeneIdFilter("ENSMUSG", "startsWith")), 
                             return.type="data.frame", columns=c("gene_id")))
  if(result_human > result_mouse){
    write.table("52","species.txt",quote=F,col.names = F,row.names = F)
    write("species,Human",file=paste(jobid,"_info.txt",sep=""),append=TRUE)
    return (list(EnsDb.Hsapiens.v86,"ENSG"))
  } else {
    write.table("53","species.txt",quote=F,col.names = F,row.names = F)
    write("species,Mouse",file=paste(jobid,"_info.txt",sep=""),append=TRUE)
    return (list(EnsDb.Mmusculus.v79,"ENSMUSG"))
  }
}
#i=1
species <- check_species(expFile)
#filename <- as.data.frame(srcFile)[1,1]
generate_seq_file <- function(filename){
  print(filename)
  genes <- read.table(as.character(filename),header = T,sep = "\t");
  new_dir <- paste(srcDir,"/",gsub(".txt", "", filename,".txt"),sep="")
  dir.create(new_dir, showWarnings = FALSE)
  #i=21
  for (i in 1:ncol(genes)) {
    this_genes <- as.character(genes[,i])
    this_genes <- this_genes[!this_genes==""]
    this_genes <- this_genes[!is.na(this_genes)]
    if(length(this_genes) > 0){
      name <- colnames(genes)[i]
      result <- genes(species[[1]], filter=list(GeneNameFilter(this_genes),GeneIdFilter(species[[2]], "startsWith")), 
                      return.type="data.frame", columns=c("gene_id"))
      if(nrow(result)>4){
        tmp <- as.data.frame(result[,1])
        colnames(tmp) <- paste("bic",i,sep = "")
        write.table(tmp, paste(new_dir,"/",colnames(tmp),".txt",sep=""),sep="\t",quote = F ,col.names=FALSE,row.names=FALSE)
      }
    }
  }
}

gene_name <- rownames(expFile)
gene_df <- genes(species[[1]], filter=list(GeneNameFilter(as.character(gene_name)),GeneIdFilter(species[[2]], "startsWith")), 
                 return.type="data.frame", columns=c("gene_id"))
if(length(which(gene_df[,2]=='')) > 0){
	gene_df <- gene_df[-which(gene_df[,2]==''),]
}
				 
write.table(gene_df,paste(jobid,"_gene_id_name.txt",sep=""),sep = "\t",quote = F,col.names = T,row.names = F)

apply(as.data.frame(srcFile), 1, generate_seq_file)


