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
library(Seurat)

args <- commandArgs(TRUE)
srcFile <- args[1] # raw user filename
outFile <- args[2] # user job id
delim <- args[3] #delimiter
is_gene_filter <- args[4] #1 for enable gene filtering
is_cell_filter <- args[5] #1 for enable cell filtering
if(delim == 'tab'){
	delim <- '\t'
}

load_test_data <- function(){
  rm(list = ls(all = TRUE))
  # setwd("/home/www/html/iris3/data/20190305183801")
  # setwd("C:/Users/flyku/Desktop/iris3_data")
  setwd("d:/Users/flyku/Documents/IRIS3-data/test_id")
  srcFile = "Guo_expression.txt"
  #srcFile = "iris3_example_expression_matrix.csv"
  outFile <- "20190408154828"
  delim <- ","
  is_gene_filter <- 1
  is_cell_filter <- 1
}
# setwd("/home/www/html/iris3/data/20190305183801")
# setwd("C:/Users/flyku/Desktop/iris3_data")
# setwd("d:/Users/flyku/Documents/IRIS3-data/test_oneregulon")
# srcFile = "Guo_expression.txt"
# srcFile = "iris3_example_expression_matrix.csv"
# outFile <- "20190305160730"
# delim <- "\t"
# is_gene_filter <- 1
# is_cell_filter <-0
#expFile <- read.csv("Goolam_cell_label.csv",header=T,sep=",",check.names = FALSE, row.names = 1)
getwd()
expFile <- read.delim(srcFile,header=T,sep=delim,check.names = FALSE, row.names = NULL)
colnames(expFile) <-  gsub('([[:punct:]])|\\s+','_',colnames(expFile))

#check if [1,1] is empty
if(colnames(expFile)[1] == ""){
  colnames(expFile)[1] = "Gene_ID"
}
#remove duplicated rows with same gene 
if(length(which(duplicated.default(expFile[,1]))) > 0 ){
  expFile <- expFile[-which(duplicated.default(expFile[,1])==T),]
}	
rownames(expFile) <- expFile[,1]
expFile<- expFile[,-1]
thres_genes <- nrow(expFile) * 0.01
thres_cells <- ncol(expFile) * 0.05

## convert Ensembl id to gene symbol
##i=1
if (length(grep('ENS',rownames(expFile))) > 0.5 * nrow(expFile) | length(grep('ens',rownames(expFile))) > 0.5 * nrow(expFile) ){

  result_human <- nrow(genes(EnsDb.Hsapiens.v86, filter=list(GeneIdFilter(rownames(expFile))), 
                             return.type="data.frame", columns=c("gene_name")))
  
  result_mouse <- nrow(genes(EnsDb.Mmusculus.v79, filter=list(GeneIdFilter(rownames(expFile))), 
                             return.type="data.frame", columns=c("gene_name")))
  if(result_human > result_mouse){
    all_match <- genes(EnsDb.Hsapiens.v86, filter=list(GeneIdFilter(rownames(expFile))), 
                       return.type="data.frame", columns=c("gene_name"))
    
  } else {
    all_match <- genes(EnsDb.Mmusculus.v79, filter=list(GeneIdFilter(rownames(expFile))), 
                       return.type="data.frame", columns=c("gene_name"))
  }
 
  expFile <- expFile[which(rownames(expFile) %in% all_match[!duplicated(all_match[,1]),2]),]
  for (i in 1:nrow(expFile)) {
    if(length(which(all_match[,2] %in% rownames(expFile)[i]))){
      rownames(expFile)[i] <- all_match[which(all_match[,2] %in% rownames(expFile)[i]),1]
    }
  }
}
get_rowname_type <- function (l, db){
  res1 <- tryCatch(nrow(select(db, keys = l, columns = c("ENTREZID", "SYMBOL","ENSEMBL"),keytype = "SYMBOL")),error = function(e) 0)
  res2 <- tryCatch(nrow(select(db, keys = l, columns = c("ENTREZID", "SYMBOL","ENSEMBL"),keytype = "ENSEMBL")),error = function(e) 0)
  res3 <- tryCatch(nrow(select(db, keys = l, columns = c("ENTREZID", "SYMBOL","ENSEMBL"),keytype = "ENTREZID")),error = function(e) 0)
  result <- c("error","SYMBOL","ENSEMBL","ENTREZID")
  result_vec <- c(1,res1,res2,res3)
  return(c(result[which.max(result_vec)],result_vec[which.max(result_vec)]))
  #write("No matched gene identifier found, please check your data.",file=paste(outFile,"_error.txt",sep=""),append=TRUE)
}

# detect species
# detect which types of identifer in rownames, 1)HGNC gene symbol 2)ensembl geneid 3) ncbi entrez id
# convert to symbol

species_file <- as.character(read.table("species.txt",header = F,stringsAsFactors = F)[,1])

# deprecated databases, about 10% of the gene id missing which cause a lot of genes filtered
suppressPackageStartupMessages(library(org.Dm.eg.db))
suppressPackageStartupMessages(library(org.Hs.eg.db))
suppressPackageStartupMessages(library(org.Mm.eg.db))
suppressPackageStartupMessages(library(org.Ce.eg.db))
suppressPackageStartupMessages(library(org.Sc.sgd.db))
suppressPackageStartupMessages(library(org.Dr.eg.db))
db <- c("Worm"=org.Ce.eg.db, "Fruit_fly"=org.Dm.eg.db, "Zebrafish"=org.Dr.eg.db,
        "Yeast"=org.Sc.sgd.db,"Mouse"=org.Mm.eg.db,"Human"=org.Hs.eg.db)

select_db <- db[which(names(db)%in%species_file)]
gene_identifier <- sapply(select_db, get_rowname_type, l=rownames(expFile))
main_species <- names(which.max(gene_identifier[2,]))
main_db <- db[which(names(db)%in%main_species)][[1]]
main_identifier <- as.character(gene_identifier[1,which.max(gene_identifier[2,])])

if(length(species_file) == 2) {
  second_species <- names(which.min(gene_identifier[2,]))
  write(paste("second_species,",second_species,sep=""),file=paste(outFile,"_info.txt",sep=""),append=TRUE)
}
total_cell_num <- ncol(expFile)
total_gene_num <- nrow(expFile)

## remove rows with empty gene name
if(length(which(rownames(expFile)=="")) > 0){
  expFile <- expFile[-which(rownames(expFile)==""),]
}


#this <- expFile[1,]
# keep the gene with number of non-0 expression value cells >= 5%
filter_gene_func <- function(this){
  if(length(which(this>0)) >= thres_cells){
    return (1)
  } else {
    return (0)
  }
}
# this <- expFile[,1]
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
  gene_index <- as.vector(apply(expFile, 1, filter_gene_func))
  new_exp <- expFile[which(gene_index == 1),]
} else {
  new_exp <- expFile
}
# apply cell filtering
if(is_cell_filter == "1"){
  cell_index <- as.vector(apply(new_exp, 2, filter_cell_func))
  new_exp <- new_exp[,which(cell_index == 1)]
} 

sample_sheet <- data.frame(groups = str_split_fixed(colnames(new_exp), "\\.+", 3), row.names = colnames(new_exp))
gene_ann <- data.frame(gene_short_name = row.names(new_exp), row.names = row.names(new_exp))
pd <- new("AnnotatedDataFrame",data=sample_sheet)
fd <- new("AnnotatedDataFrame",data=gene_ann)

tpm_mat <- new_exp
tpm_mat <- apply(tpm_mat, 2, function(x) x / sum(x) * 1e6)

# if reads are integers, normalize with 'negbinomial.size()'
# for log-transformed FPKM, TPM, RPKM, if value < 10, use gaussianff()
# for FPKM, TPM, RPKM judge values not integers and some >10, use tobit()

if(all(as.numeric(unlist(expFile))%%1==0)){
  URMM_all_std <- newCellDataSet(as.matrix(new_exp),phenoData = pd,featureData =fd,
                                 expressionFamily = negbinomial.size())
} else if (all(as.numeric(unlist(expFile)) < 10)){
  URMM_all_std <- newCellDataSet(as.matrix(new_exp),phenoData = pd,featureData =fd,
                                 expressionFamily = gaussianff())
} else {
  URMM_all_std <- newCellDataSet(as.matrix(new_exp),phenoData = pd,featureData =fd,
                                 expressionFamily = tobit())
 
}

new_exp <-as.matrix(URMM_all_std@assayData$exprs)

# calculate filtering rate
filter_gene_num <- nrow(expFile)-nrow(new_exp)
filter_gene_rate <- formatC(filter_gene_num/total_gene_num,digits = 2)
filter_cell_num <- ncol(expFile)-ncol(new_exp)
filter_cell_rate <- formatC(filter_cell_num/total_cell_num,digits = 2)
if(filter_cell_num == 0){
  filter_cell_rate <- '0'
}
new_exp <- log1p(new_exp)

#write.table(cbind(filter_num,filter_rate,nrow(expFile)), paste(outFile,"_filtered_rate.txt",sep = ""),sep = "\t", row.names = F,col.names = F,quote = F)
write(paste("filter_gene_num,",as.character(filter_gene_num),sep=""),file=paste(outFile,"_info.txt",sep=""),append=TRUE)
write(paste("total_gene_num,",as.character(total_gene_num),sep=""),file=paste(outFile,"_info.txt",sep=""),append=TRUE)
write(paste("filter_gene_rate,",as.character(filter_gene_rate),sep=""),file=paste(outFile,"_info.txt",sep=""),append=TRUE)
write(paste("filter_cell_num,",as.character(filter_cell_num),sep=""),file=paste(outFile,"_info.txt",sep=""),append=TRUE)
write(paste("total_cell_num,",as.character(total_cell_num),sep=""),file=paste(outFile,"_info.txt",sep=""),append=TRUE)
write(paste("filter_cell_rate,",as.character(filter_cell_rate),sep=""),file=paste(outFile,"_info.txt",sep=""),append=TRUE)
write.table(expFile,paste(outFile,"_raw_expression.txt",sep = ""), row.names = T,col.names = T,sep="\t",quote=FALSE)
write.table(new_exp,paste(outFile,"_filtered_expression.txt",sep = ""), row.names = T,col.names = T,sep="\t",quote=FALSE)
write(paste("main_species,",main_species,sep=""),file=paste(outFile,"_info.txt",sep=""),append=TRUE)



install_db <- function(){
  bioc_packages <- c(
    "BSgenome.Celegans.UCSC.ce11", "TxDb.Celegans.UCSC.ce11.refGene",
    "BSgenome.Hsapiens.UCSC.hg38", "TxDb.Hsapiens.UCSC.hg38.knownGene",
    "BSgenome.Mmusculus.UCSC.mm10", "TxDb.Mmusculus.UCSC.mm10.knownGene",
    "BSgenome.Scerevisiae.UCSC.sacCer3", "TxDb.Scerevisiae.UCSC.sacCer3.sgdGene",
    "BSgenome.Drerio.UCSC.danRer10","TxDb.Drerio.UCSC.danRer10.refGene",
    "BSgenome.Dmelanogaster.UCSC.dm6","TxDb.Dmelanogaster.UCSC.dm6.ensGene",
    "org.Ce.eg.db", "org.Dm.eg.db", "org.Dr.eg.db", "org.Sc.sgd.db", "org.Mm.eg.db","org.Hs.eg.db"
  )
  np <- bioc_packages[!(bioc_packages %in% installed.packages()[,"Package"])]
  if (!require("BiocManager")) install.packages("BiocManager")
  BiocManager::install(np)
}

detach_all <- function() {
  
  basic.packages <- c("package:stats","package:graphics","package:grDevices","package:utils","package:datasets","package:methods","package:base")
  package.list <- search()[ifelse(unlist(gregexpr("package:",search()))==1,TRUE,FALSE)]
  package.list <- setdiff(package.list,basic.packages)
  if (length(package.list)>0)  for (package in package.list) detach(package, character.only=TRUE)
}

#detach_all()

