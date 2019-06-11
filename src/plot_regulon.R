#######  Plot regulon ##########
if(!require(Seurat)) {
  install.packages("Seurat")
} 
if(!require(hdf5r)) {
  install.packages("hdf5r")
} 

if(!require(Matrix)) {
  install.packages("Matrix")
}
if(!require(plotly)){
  install.packages("plotly")
}
if (!require("RColorBrewer")) {
  install.packages("RColorBrewer")
}
if (!require("Polychrome")) {
  install.packages("Polychrome")
  library(Polychrome)
}
args <- commandArgs(TRUE)
#setwd("D:/Users/flyku/Documents/IRIS3-data/test_zscore")
#setwd("/var/www/html/iris3/data/2019052895653/")
#srcDir <- getwd()
#id <-"CT1S-R5" 
srcDir <- args[1]
id <- args[2]

setwd(srcDir)
load("plot_regulon.RData")
regulon_ct <-gsub( "-.*$", "", id)
regulon_ct <-gsub("[[:alpha:]]","",regulon_ct)
regulon_id <- gsub( ".*R", "", id)
regulon_id <- gsub("[[:alpha:]]","",regulon_id)
#save.image(file="plot_regulon.RData")
quiet <- function(x) { 
  sink(tempfile()) 
  on.exit(sink()) 
  invisible(force(x)) 
} 
png(paste("regulon_id/",id,".png",sep = ""),width=800, height=800)
Plot.regulon2D(reduction.method = "tsne",regulon = as.numeric(regulon_id),customized =T)  
quiet(dev.off())

