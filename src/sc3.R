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


# expFile <- "1103_filtered_expression.txt"
# jobid <- 1103
# label_file <- "1103_cell_label.txt"


#setwd("C:/Users/flyku/Desktop/iris3")
exp_data<- read.delim(expFile,check.names = FALSE, header=TRUE,row.names = 1)
label_file
if (label_file == 0 | label_file==1){
  cell_info <- colnames(exp_data)
} else {
  cell_info <- read.delim(label_file,header=TRUE,row.names = 1)
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

a <- as.data.frame(colData(sce))
a <- cbind(rownames(a),a[,ncol(a)])
colnames(a) <- c("cell_name","label")
write.table(a,paste(jobid,"_sc3_label.txt",sep = ""),quote = F,row.names = F,sep = "\t")
