########## SC3 ##################
# install
#if (!requireNamespace("BiocManager", quietly = TRUE))
#  install.packages("BiocManager")
#BiocManager::install("SC3", version = "3.8")
#BiocManager::install("scater", version = "3.8")
#BiocManager::install("XVector", version = "3.8")
#BiocManager::install("Biobase", version = "3.8")
#BiocManager::install("BiocGenerics", version = "3.8")
#BiocManager::install("purrr", version = "3.8")
#SingleCellExperiment
#install.packages("shiny")
#remove.packages( installed.packages( priority = "NA" )[,1] )
# load packages
library(SingleCellExperiment)
library(SC3)
library(scater)

args <- commandArgs(TRUE)
expFile <- args[1] # raw or filtered expression file name
jobid <- args[2] # user job id
label_file <- 1
label_file <- args[3] # user label or 1
delimiter <- args[4] #delimiter
param_k <- character()
param_k <- args[5] #k parameter for sc3

###test
# setwd("D:/Users/flyku/Documents/IRIS3-data/test_id")
# srcDir <- getwd()
# jobid <-20190408154827 
# expFile <- "20190408154827_filtered_expression.txt"
# label_file <- "1"
# delimiter <- ","
# param_k <- '0'


exp_data<- read.delim(expFile,check.names = FALSE, header=TRUE,row.names = 1)
label_file
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
