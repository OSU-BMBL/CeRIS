#######  Convert gene name -> Ensembl gene id ##########
#######  Create a folder by filename, inside folder create each module by clusters  ##########

#source("https://bioconductor.org/biocLite.R"); 
#biocLite("ensembldb") 
#biocLite("EnsDb.Hsapiens.v86")
#biocLite("EnsDb.Mmusculus.v79")
GenomicFeatures
biocLite("GenomicAlignments")
library(ensembldb)
library(EnsDb.Hsapiens.v86)
#setwd("C:/Users/flyku/Desktop/iris3")
getwd()
args <- commandArgs(TRUE)
srcFile <- args[1]
srcFile <- "20181103_CT_3_bic.txt"
#setwd("D:/Users/flyku/Documents/IRIS3-R/")
genes <- read.table(srcFile,header = T,sep = "\t");

this <- genes[,1]
i=1

get_row_num <- function (this){
  num = 0
  for (i in 1:length(this)) {
    if(nchar(as.character(this[i]))>0){
      num = num +  1
    }
  }
  return (num)
}

# res <- as.data.frame(apply(genes, 2, get_row_num))
# boxplot(res[,1])
# summary(res[,1])

filename <- gsub("\\.txt","",srcFile)
dir.create(file.path(getwd(), filename), showWarnings = FALSE)
setwd(file.path(getwd(), filename))
new_bic <- data.frame()

  for (i in 1:ncol(genes)) {
    name <- colnames(genes)[i]
    result <- genes(EnsDb.Hsapiens.v86, filter=list(GenenameFilter(genes[,i]),GeneIdFilter("ENSG", "startsWith")), 
                    return.type="data.frame", columns=c("gene_id"))
    if(nrow(result>4)){
      tmp <- as.data.frame(result[,1])
      colnames(tmp) <- paste("bic",i,sep = "")
      write.table(tmp, paste(colnames(tmp),".txt",sep=""),sep="\t",quote = F ,col.names=FALSE,row.names=FALSE)
    }
  }
  
  