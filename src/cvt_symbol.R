#######  Convert gene name -> Ensembl gene id ##########
#######  Create a folder by filename, inside folder create each module by clusters  ##########

#if (!requireNamespace("BiocManager", quietly = TRUE))
#  install.packages("BiocManager")
#BiocManager::install("GenomicAlignments", version = "3.8")
#BiocManager::install("ensembldb", version = "3.8")
#BiocManager::install("EnsDb.Hsapiens.v86", version = "3.8")
library(GenomicAlignments)
library(ensembldb)
library(EnsDb.Hsapiens.v86)
#setwd("C:/Users/flyku/Desktop/iris3")


args <- commandArgs(TRUE)
srcDir <- args[1]
setwd(srcDir)
getwd()
#srcDir <-  getwd()
srcFile <- list.files(srcDir,pattern = "*_bic.txt")
#setwd("D:/Users/flyku/Documents/IRIS3-R/")

get_row_num <- function (this){
  num = 0
  for (i in 1:length(this)) {
    if(nchar(as.character(this[i]))>0){
      num = num +  1
    }
  }
  return (num)
}


generate_seq_file <- function(filename){
  genes <- read.table(filename,header = T,sep = "\t");
  new_dir <- paste(srcDir,"/",gsub(".txt", "", filename,".txt"),sep="")
  dir.create(new_dir)
  for (i in 1:ncol(genes)) {
    name <- colnames(genes)[i]
    result <- genes(EnsDb.Hsapiens.v86, filter=list(GenenameFilter(as.character(genes[,i])),GeneIdFilter("ENSG", "startsWith")), 
                    return.type="data.frame", columns=c("gene_id"))
    if(nrow(result)>4){
      tmp <- as.data.frame(result[,1])
      colnames(tmp) <- paste("bic",i,sep = "")
      write.table(tmp, paste(new_dir,"/",colnames(tmp),".txt",sep=""),sep="\t",quote = F ,col.names=FALSE,row.names=FALSE)
    }
  }
}

  

apply(as.data.frame(srcFile), 1, generate_seq_file)


