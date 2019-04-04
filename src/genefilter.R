####### preprocessing expression matrix based on SC3 ##########

#removes genes/transcripts that are either expressed (expression value > 2) in less than X% of cells (rare genes/transcripts) 
#or expressed (expression value > 0) in at least (100 ??? X)% of cells (ubiquitous genes/transcripts). 
#By default, X is set at 6.

library(GenomicAlignments)
library(ensembldb)
library(EnsDb.Hsapiens.v86)
library(EnsDb.Mmusculus.v79)
library(monocle)
library(stringr)
args <- commandArgs(TRUE)
srcFile <- args[1] # raw user filename
outFile <- args[2] # user job id
delim <- args[3] #delimiter
is_gene_filter <- args[4] #1 for enable gene filtering
is_cell_filter <- args[5] #1 for enable cell filtering
if(delim == 'tab'){
	delim <- '\t'
}
# setwd("/home/www/html/iris3/data/20190305183801")
# setwd("C:/Users/Cankun.Wang/Desktop/iris3")
# setwd("d:/Users/flyku/Documents/IRIS3-data/test_oneregulon")
# srcFile = "count-data-small.csv"
# srcFile = "iris3_example_expression_matrix.csv"
# outFile <- "20190305160730"
# delim <- ","
# is_gene_filter <- 1
# is_cell_filter <- 1
#yan.test <- read.csv("Goolam_cell_label.csv",header=T,sep=",",check.names = FALSE, row.names = 1)
getwd()
yan.test <- read.delim(srcFile,header=T,sep=delim,check.names = FALSE, row.names = NULL)
colnames(yan.test) <-  gsub('([[:punct:]])|\\s+','_',colnames(yan.test))

#check if [1,1] is empty
if(colnames(yan.test)[1] == ""){
  colnames(yan.test)[1] = "Gene_ID"
}
#remove duplicated rows with same gene 
if(length(which(duplicated.default(yan.test[,1]))) > 0 ){
  yan.test <- yan.test[-which(duplicated.default(yan.test[,1])==T),]
}	
rownames(yan.test) <- yan.test[,1]
yan.test<- yan.test[,-1]
thres_genes <- nrow(yan.test) * 0.01
thres_cells <- ncol(yan.test) * 0.05
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
 
  yan.test <- yan.test[which(rownames(yan.test) %in% all_match[!duplicated(all_match[,1]),2]),]
  for (i in 1:nrow(yan.test)) {
    if(length(which(all_match[,2] %in% rownames(yan.test)[i]))){
      rownames(yan.test)[i] <- all_match[which(all_match[,2] %in% rownames(yan.test)[i]),1]
    }
  }
}
#this <- yan.test[977,]
# keep the gene with number of non-0 expression value cells >= 5%
filter_gene_func <- function(this){
  if(length(which(this>0)) >= thres_cells){
    return (1)
  } else {
    return (0)
  }
}
# this <- yan.test[,1]
# keep the cell with number of non-0 expression value gene >= 1%
filter_cell_func <- function(this){
  if(length(which(this>0)) >= thres_genes){
    return (1)
  } else {
    return (0)
  }
}

# apply gene filtering
if(is_gene_filter == "1"){
  gene_index <- as.vector(apply(yan.test, 1, filter_gene_func))
  new_yan <- yan.test[which(gene_index == 1),]
} else {
  new_yan <- yan.test
}
# apply cell filtering
if(is_cell_filter == "1"){
  cell_index <- as.vector(apply(yan.test, 2, filter_cell_func))
  yan.test <- yan.test[,which(cell_index == 1)]
} else {
  new_yan <- yan.test
}

sample_sheet <- data.frame(groups = str_split_fixed(colnames(yan.test), "\\.+", 3), row.names = colnames(yan.test))
gene_ann <- data.frame(gene_short_name = row.names(yan.test), row.names = row.names(yan.test))
pd <- new("AnnotatedDataFrame",data=sample_sheet)
fd <- new("AnnotatedDataFrame",data=gene_ann)

tpm_mat <- yan.test
tpm_mat <- apply(tpm_mat, 2, function(x) x / sum(x) * 1e6)

# if reads are integers, normalize with 'negbinomial.size()'
# for log-transformed FPKM, TPM, RPKM, if value < 10, use gaussianff()
# for FPKM, TPM, RPKM judge values not integers and some >10, use tobit()

if(all(as.numeric(unlist(yan.test))%%1==0)){
  URMM_all_std <- newCellDataSet(as.matrix(tpm_mat),phenoData = pd,featureData =fd,
                                 expressionFamily = negbinomial.size())
} else if (all(as.numeric(unlist(yan.test)) < 10)){
  URMM_all_std <- newCellDataSet(as.matrix(tpm_mat),phenoData = pd,featureData =fd,
                                 expressionFamily = gaussianff())
} else {
  URMM_all_std <- newCellDataSet(as.matrix(tpm_mat),phenoData = pd,featureData =fd,
                                 expressionFamily = tobit())
}

result_matrix <-as.matrix(URMM_all_std@assayData$exprs)

# calculate filtering rate
filter_gene_num <- nrow(yan.test)-nrow(new_yan)
filter_gene_rate <- formatC(filter_gene_num/nrow(yan.test),digits = 2)
filter_cell_num <- ncol(yan.test)-ncol(new_yan)
filter_cell_rate <- formatC(filter_cell_num/nrow(yan.test),digits = 2)
if(filter_cell_num == 0){
  filter_cell_rate <- '0'
}

#write.table(cbind(filter_num,filter_rate,nrow(yan.test)), paste(outFile,"_filtered_rate.txt",sep = ""),sep = "\t", row.names = F,col.names = F,quote = F)
write(paste("filter_gene_num,",as.character(filter_gene_num),sep=""),file=paste(outFile,"_info.txt",sep=""),append=TRUE)
write(paste("total_gene_num,",as.character(nrow(yan.test)),sep=""),file=paste(outFile,"_info.txt",sep=""),append=TRUE)
write(paste("filter_gene_rate,",as.character(filter_gene_rate),sep=""),file=paste(outFile,"_info.txt",sep=""),append=TRUE)
write(paste("filter_cell_num,",as.character(filter_cell_num),sep=""),file=paste(outFile,"_info.txt",sep=""),append=TRUE)
write(paste("total_cell_num,",as.character(ncol(yan.test)),sep=""),file=paste(outFile,"_info.txt",sep=""),append=TRUE)
write(paste("filter_cell_rate,",as.character(filter_cell_rate),sep=""),file=paste(outFile,"_info.txt",sep=""),append=TRUE)
write.table(result_matrix,paste(outFile,"_raw_expression.txt",sep = ""), row.names = T,col.names = T,sep="\t",quote=FALSE)
write.table(result_matrix,paste(outFile,"_filtered_expression.txt",sep = ""), row.names = T,col.names = T,sep="\t",quote=FALSE)
#write.table(yan.test,"Goolam_cell_label.txt",sep="\t")
#write.csv(new_yan,"Goolam_expression_filtered.csv")










