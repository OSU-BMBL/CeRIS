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
label_file <- 0
label_file <- args[3] # user label or empty string
delimiter <- args[4] #delimiter
###test
# setwd("D:/Users/flyku/Documents/IRIS3-data/test_regulon")
# srcDir <- getwd()
# jobid <-2018122223516 
# expFile <- "2018122223516_filtered_expression.txt"
# label_file <- "iris3_example_expression_label.csv" #set empty 
# delimiter <- ","


exp_data<- read.delim(expFile,check.names = FALSE, header=TRUE,row.names = 1)
label_file
if (label_file == 0 | label_file==1){
  cell_info <- colnames(exp_data)
} else {
  cell_info <- read.table(label_file,check.names = FALSE, header=TRUE,sep = delimiter)
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
sce <- sc3_estimate_k(sce)
sce <- sc3_calc_dists(sce)
sce <- sc3_calc_transfs(sce)
sce <- sc3_kmeans(sce, ks = metadata(sce)$sc3$k_estimation)
sce <- sc3_calc_consens(sce)
# get row data for section 5.2 Silhouette Plot
# silh stores the bar width
# modify k to the number of cluster
silh <- metadata(sce)$sc3$consensus[[1]]$silhouette
#silh[,2] = seq(1:nrow(silh))
silh[,2] =  cell_info
silh_out <- cbind(silh[,1],cell_info,silh[,3])
silh_out <- silh_out[order(silh[,1]),]
write.table(silh_out,paste(jobid,"_silh.txt",sep=""),sep = ",",quote = F,col.names = F,row.names = F)
#apply(silh, 1, write,file=paste(jobid,"_silh.txt",sep=""),append=TRUE,sep = ",")

a <- as.data.frame(colData(sce))
a <- cbind(rownames(a),a[,ncol(a)])
colnames(a) <- c("cell_name","label")
write.table(a,paste(jobid,"_sc3_label.txt",sep = ""),quote = F,row.names = F,sep = "\t")
