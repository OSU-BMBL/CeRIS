####### preprocessing expression matrix based on SC3 ##########

#removes genes/transcripts that are either expressed (expression value > 2) in less than X% of cells (rare genes/transcripts) 
#or expressed (expression value > 0) in at least (100 ??? X)% of cells (ubiquitous genes/transcripts). 
#By default, X is set at 6.

library(GenomicAlignments)
library(ensembldb)
library(EnsDb.Hsapiens.v86)
library(EnsDb.Mmusculus.v79)

args <- commandArgs(TRUE)
srcFile <- args[1] # raw user filename
outFile <- args[2] # user job id
delim <- args[3] #delimiter
is_filter <- args[4] #1 for enable filter
if(delim == 'tab'){
	delim <- '\t'
}
# setwd("d:/Users/flyku/Documents/IRIS3-data/test_oneregulon")
# srcFile = "Read counts.csv"
# outFile <- "2018122864543"
# delim <- ","
# is_filter <- 1

#yan.test <- read.csv("Goolam_cell_label.csv",header=T,sep=",",check.names = FALSE, row.names = 1)
getwd()
yan.test <- read.delim(srcFile,header=T,sep=delim,check.names = FALSE, row.names = 1)


# convert Ensembl id to gene symbol
#i=1
if (length(grep('ENS',rownames(yan.test))) > 0.5 * nrow(yan.test) | length(grep('ens',rownames(yan.test))) > 0.5 * nrow(yan.test) ){

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



# obtain a matrix of gene length in expresison matrix, used for TPM normalization
# if the last row read counts are integers, skip the normalizaiotn
if(all(as.numeric(unlist(yan.test[nrow(yan.test),]))%%1==0)){
  
  df_gene_length <- genes(EnsDb.Hsapiens.v86, filter=list(GeneNameFilter(rownames(yan.test))), 
                          return.type="data.frame", columns=c("gene_seq_start","gene_seq_end"))
  df_gene_length[,5] <- df_gene_length[,2] - df_gene_length[,1] + 1
  colnames(df_gene_length)[5] <- "gene_length"
  gene_length <- df_gene_length[match(rownames(yan.test), df_gene_length$gene_name), ]
  if(nrow(yan.test[!is.na(gene_length$gene_name),])>1) {
    yan.test <- yan.test[!is.na(gene_length$gene_name),]
    gene_length <- gene_length[!is.na(gene_length$gene_name),c(4,5)]
    tpm <- function(counts, lengths) {
      rate <- counts / lengths
      rate / sum(rate) * 1e6
    }
    yan.test <- apply(yan.test, 2, function(x) tpm(x, gene_length$gene_length))
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










