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
genes <- read.table(srcFile,header = T,sep = "\t");
filename <- gsub("\\.txt","",srcFile)
setwd("C:/Users/flyku/Desktop/iris3/")
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
  
  