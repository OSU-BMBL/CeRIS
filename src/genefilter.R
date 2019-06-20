####### preprocessing expression matrix based on SC3 ##########

#removes genes/transcripts that are either expressed (expression value > 2) in less than X% of cells (rare genes/transcripts) 
#or expressed (expression value > 0) in at least (100 ??? X)% of cells (ubiquitous genes/transcripts). 
#By default, X is set at 6.

#library(GenomicAlignments)
#library(ensembldb)
#BiocManager::install("SC3")
suppressPackageStartupMessages(library(stringr))
suppressPackageStartupMessages(library(Seurat))
suppressPackageStartupMessages(library(hdf5r))
suppressPackageStartupMessages(library(stringr))
library(SingleCellExperiment)
library(SC3)
library(scater)


args <- commandArgs(TRUE)
srcFile <- args[1] # raw user filename
outFile <- args[2] # user job id
delim <- args[3] #delimiter
is_gene_filter <- args[4] #1 for enable gene filtering
is_cell_filter <- args[5] #1 for enable cell filtering
label_file <- 1
label_file <- args[6] # user label file name or 1
param_k <- character()
param_k <- args[5] #k parameter for sc3


if(delim == 'tab'){
	delim <- '\t'
}
if(delim == 'space'){
  delim <- ' '
}
load_test_data <- function(){
  rm(list = ls(all = TRUE))
  # setwd("/home/www/html/iris3/data/20190305183801")
  # setwd("C:/Users/flyku/Desktop/iris3_data")
  setwd("/home/cyz/Bigstore/BigData/runningdata/outs/websiteoutput/test_zscore")
  #srcFile = "single_cell.csv"
  srcFile = "iris3_example_expression_matrix.csv"
  outFile <- "2019052895653"
  delim <- ","
  is_gene_filter <- 1
  is_cell_filter <- 1
  label_file<-1
  param_k<-character()
}

##############################
# define a fucntion for reading in 10X hd5f data and cell gene matrix by input (TenX) or (CellGene)
read_data<-function(x=NULL,read.method=NULL,sep="\t",...){
  if(!is.null(x)){
    if(!is.null(read.method)){
      if(read.method !="TenX.h5"&&read.method!="CellGene"&&read.method!="TenX.folder"){
        stop("wrong 'read.method' argument, please choose 'TenX.h5','TenX.folder', or 'CellGene'!")}
      if(read.method == "TenX.h5"){
        tmp_x<-Read10X_h5(x)
        return(tmp_x)
      }else if(read.method =="TenX.folder"){
        tmp_x<-Read10X(x)
        return(tmp_x)
      } else if(read.method == "CellGene"){# read in cell * gene matrix, if there is error report, back to 18 line to run again.
        tmp_x<-read.delim(x,header = T,row.names = NULL,check.names = F,sep=sep,...)
        
        return(tmp_x)
      }
    }
  }else {stop("Missing 'x' argument, please input correct data")}
}

getwd()

expFile <- read_data(x = srcFile,read.method = "CellGene",sep = delim)
colnames(expFile) <-  gsub('([[:punct:]])|\\s+','_',colnames(expFile))
#check if [1,1] is empty
if(colnames(expFile)[1] == ""){
  colnames(expFile)[1] = "Gene_ID"
}
total_gene_num <- nrow(expFile)
#remove duplicated rows with same gene 
if(length(which(duplicated.default(expFile[,1]))) > 0 ){
  expFile <- expFile[-which(duplicated.default(expFile[,1])==T),]
}	
rownames(expFile) <- expFile[,1]
expFile<- expFile[,-1]

total_cell_num <- ncol(expFile)
thres_genes <- nrow(expFile) * 0.01
thres_cells <- ncol(expFile) * 0.05

# detect rownames gene list with identifer by the largest number of matches: 1) gene symbol 2)ensembl geneid 3) ncbi entrez id

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
all_match <- select(main_db, keys = rownames(expFile), columns = c("SYMBOL","ENSEMBL"),keytype = main_identifier)
expFile <- merge(expFile,all_match,by.x=0,by.y=main_identifier)
expFile <- na.omit(expFile)

if (main_identifier == "ENSEMBL") {
  expFile <- expFile[!duplicated(expFile[,ncol(expFile)]),]
  rownames(expFile) <- expFile[,ncol(expFile)]
} else {
  expFile <- expFile[!duplicated(expFile[,1]),]
  rownames(expFile) <- expFile[,1]
}

expFile <- expFile[,c(-1,-(ncol(expFile)))]

## remove rows with empty gene name
if(length(which(rownames(expFile)=="")) > 0){
  expFile <- expFile[-which(rownames(expFile)==""),]
}
expFile<-as.sparse(expFile)

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

# normalization using Seurat
new_exp<-CreateSeuratObject(new_exp)
#new_exp<-GetAssayData(object = my.object,slot = "counts")

new_exp<-NormalizeData(new_exp,normalization.method = "LogNormalize",scale.factor = 10000)
new_exp<-SCTransform()

# calculate filtering rate
#filter_gene_num <- nrow(expFile)-nrow(new_exp)
filter_gene_num <- total_gene_num-nrow(new_exp)
filter_gene_rate <- formatC(filter_gene_num/total_gene_num,digits = 2)
filter_cell_num <- ncol(expFile)-ncol(new_exp)
filter_cell_rate <- formatC(filter_cell_num/total_cell_num,digits = 2)
if(filter_cell_num == 0){
  filter_cell_rate <- '0'
}


new_exp <- GetAssayData(object = new_exp,slot = "counts")

#write.table(cbind(filter_num,filter_rate,nrow(expFile)), paste(outFile,"_filtered_rate.txt",sep = ""),sep = "\t", row.names = F,col.names = F,quote = F)
write(paste("filter_gene_num,",as.character(filter_gene_num),sep=""),file=paste(outFile,"_info.txt",sep=""),append=TRUE)
write(paste("total_gene_num,",as.character(total_gene_num),sep=""),file=paste(outFile,"_info.txt",sep=""),append=TRUE)
write(paste("filter_gene_rate,",as.character(filter_gene_rate),sep=""),file=paste(outFile,"_info.txt",sep=""),append=TRUE)
write(paste("filter_cell_num,",as.character(filter_cell_num),sep=""),file=paste(outFile,"_info.txt",sep=""),append=TRUE)
write(paste("total_cell_num,",as.character(total_cell_num),sep=""),file=paste(outFile,"_info.txt",sep=""),append=TRUE)
write(paste("filter_cell_rate,",as.character(filter_cell_rate),sep=""),file=paste(outFile,"_info.txt",sep=""),append=TRUE)
write(paste("main_species,",main_species,sep=""),file=paste(outFile,"_info.txt",sep=""),append=TRUE)
write.table(expFile,paste(outFile,"_raw_expression.txt",sep = ""), row.names = T,col.names = T,sep="\t",quote=FALSE)
write.table(new_exp,paste(outFile,"_filtered_expression.txt",sep = ""), row.names = T,col.names = T,sep="\t",quote=FALSE)



if (label_file == 0 | label_file==1){
  cell_info <- colnames(exp_data)
} else {
  if(delimiter == 'tab'){
    delimiter <- '\t'
  }
  if(delimiter == 'space'){
    delimiter <- ' '
  }
  cell_info <- read.table(label_file,check.names = FALSE, header=TRUE,sep = delimiter)
  cell_info[,2] <- as.factor(cell_info[,2])
}

# create a SingleCellExperiment object
sce <- SingleCellExperiment(
  assays = list(
    counts = as.matrix(exp_data),
    logcounts = log2(as.matrix(exp_data) + 1)
  ), 
  colData = cell_info
)

# define feature names in feature_symbol column
rowData(sce)$feature_symbol <- rownames(sce)
# remove features with duplicated names
sce <- sce[!duplicated(rowData(sce)$feature_symbol), ]
sce <- sc3_prepare(sce)

if (as.numeric(param_k)>0){
  sce <- sc3_calc_dists(sce)
  sce <- sc3_calc_transfs(sce)
  sce <- sc3_kmeans(sce, ks = as.numeric(param_k))
} else {
  sce <- sc3_estimate_k(sce)
  sce <- sc3_calc_dists(sce)
  sce <- sc3_calc_transfs(sce)
  sce <- sc3_kmeans(sce, ks = metadata(sce)$sc3$k_estimation)
}

sce <- sc3_calc_consens(sce)
# get row data for section 5.2 Silhouette Plot
# silh stores the bar width
# modify k to the number of cluster
silh <- metadata(sce)$sc3$consensus[[1]]$silhouette
#silh[,2] = seq(1:nrow(silh))
save_image <- function(type,filetype){
  if(filetype == "jpeg" || filetype == "png"){
    type(file=paste("saving_plot1.",as.character(filetype),sep=""),width=1200, height=1200)
  } else if (filetype == "pdf"){
    type(file=paste("saving_plot1.",as.character(filetype),sep=""))
  } else if (filetype == "emf"){
    library(devEMF)
    emf(file="saving_plot1.emf", emfPlus = FALSE)
  }
  if (as.numeric(param_k)>0){
    sc3_plot_consensus(sce,param_k,show_pdata=c(colnames(colData(sce))[2]))
  } else {
    sc3_plot_consensus(sce,metadata(sce)$sc3$k_estimation,show_pdata=c(colnames(colData(sce))[2]))
  }
  dev.off()
}

if (label_file == 1){
  silh_out <- cbind(silh[,1],as.character(cell_info),silh[,3])
} else {
  silh_out <- cbind(silh[,1],as.character(cell_info[,1]),silh[,3])
}

save_image(pdf,"pdf")
save_image(emf,"emf")
save_image(png,"png")
save_image(jpeg,"jpeg")
silh_out <- silh_out[order(silh[,1]),]
write.table(silh_out,paste(jobid,"_silh.txt",sep=""),sep = ",",quote = F,col.names = F,row.names = F)
#apply(silh, 1, write,file=paste(jobid,"_silh.txt",sep=""),append=TRUE,sep = ",")

a <- as.data.frame(colData(sce))
a <- cbind(rownames(a),a[,ncol(a)])
colnames(a) <- c("cell_name","label")
write.table(a,paste(jobid,"_sc3_label.txt",sep = ""),quote = F,row.names = F,sep = "\t")


