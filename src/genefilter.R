####### preprocessing expression matrix based on SC3 ##########

#removes genes/transcripts that are either expressed (expression value > 2) in less than X% of cells (rare genes/transcripts) 
#or expressed (expression value > 0) in at least (100 ??? X)% of cells (ubiquitous genes/transcripts). 
#By default, X is set at 6.
args <- commandArgs(TRUE)
srcFile <- args[1] # raw user filename
outFile <- args[2] # user job id
delim <- args[3] #delimiter
is_filter <- args[4] #1 for enable filter
if(delim == 'tab'){
	delim <- '\t'
}
BiocManager::install("org.Hs.eg.db", version = "3.8")

# srcFile = "C:/Users/flyku/Desktop/Yan_expression.csv"
# srcFile = "C:/Users/flyku/Desktop/GSE37704.csv"
# srcFile = "/home/www/html/iris3/program/test_yan.csv";
# outFile <- "1103"
# delim <- ","
# is_filter <- 1

#yan.test <- read.csv("Goolam_cell_label.csv",header=T,sep=",",check.names = FALSE, row.names = 1)
getwd()
yan.test <- read.delim(srcFile,header=T,sep=delim,check.names = FALSE, row.names = 1)

# change Ensembl to symbol
#i=1
if (length(grep('ENS',rownames(yan.test))) > 0.5 * nrow(yan.test) | length(grep('ens',rownames(yan.test))) > 0.5 * nrow(yan.test) ){
  library(GenomicAlignments)
  library(ensembldb)
  library(EnsDb.Hsapiens.v86)
  library(EnsDb.Mmusculus.v79)
  result_human <- nrow(genes(EnsDb.Hsapiens.v86, filter=list(GeneIdFilter(rownames(yan.test))), 
                             return.type="data.frame", columns=c("gene_name")))
  
  result_mouse <- nrow(genes(EnsDb.Mmusculus.v79, filter=list(GeneIdFilter(rownames(yan.test))), 
                             return.type="data.frame", columns=c("gene_name")))
  if(result_human > result_mouse){
    all_match <- genes(EnsDb.Hsapiens.v86, filter=list(GeneIdFilter(rownames(yan.test))), 
                       return.type="data.frame", columns=c("gene_name"))
    
  } else {
    all_match <- genes(EnsDb.Mmusculus.v79, filter=list(GeneIdFilter(rownames(yan.test))), 
                       return.type="data.frame", columns=c("gene_name"))
  }
  yan.test <- yan.test[-which(rownames(yan.test) %in% all_match[duplicated(all_match[,1]),2]),]
  for (i in 1:nrow(yan.test)) {
    if(length(which(all_match[,2] %in% rownames(yan.test)[i]))){
      rownames(yan.test)[i] <- all_match[which(all_match[,2] %in% rownames(yan.test)[i]),1]
    }
  }
}



nrare <- ncol(yan.test) * 0.06
nubi <- ncol(yan.test) * 0.94
new_yan <- data.frame()
filter_func <- function(this){
  if(length(which(this>2)) >= nrare && length(which(this==0)) <= nubi){
    return (1)
  } else {
    return (0)
  }
}

new_yan_index <- as.vector(apply(yan.test, 1, filter_func))
if(is_filter == 1){
  new_yan <- yan.test[which(new_yan_index == 1),]
} else{
  new_yan <- yan.test
}


new_yan <- log1p(new_yan)
filter_num <- nrow(yan.test)-nrow(new_yan)
filter_rate <- formatC(filter_num/nrow(yan.test),digits = 2)

#write.table(cbind(filter_num,filter_rate,nrow(yan.test)), paste(outFile,"_filtered_rate.txt",sep = ""),sep = "\t", row.names = F,col.names = F,quote = F)
write(paste("filter_num,",as.character(filter_num),sep=""),file=paste(outFile,"_info.txt",sep=""),append=TRUE)
write(paste("total_num,",as.character(nrow(yan.test)),sep=""),file=paste(outFile,"_info.txt",sep=""),append=TRUE)
write(paste("filter_rate,",as.character(filter_rate),sep=""),file=paste(outFile,"_info.txt",sep=""),append=TRUE)
write.table(yan.test,paste(outFile,"_raw_expression.txt",sep = ""), row.names = T,col.names = T,sep="\t",quote=FALSE)
write.table(new_yan,paste(outFile,"_filtered_expression.txt",sep = ""), row.names = T,col.names = T,sep="\t",quote=FALSE)
#write.table(yan.test,"Goolam_cell_label.txt",sep="\t")
#write.csv(new_yan,"Goolam_expression_filtered.csv")










