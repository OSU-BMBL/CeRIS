#######  Combine all bbc results for clustergrammer input ##########


library(GenomicAlignments)
library(ensembldb)
library(EnsDb.Hsapiens.v86)
library(magic)
library(Matrix)
library(reshape2)
args <- commandArgs(TRUE)

srcDir <- args[1]

getwd()

setwd("D:/Users/flyku/Documents/IRIS3-R/data")
workdir <- getwd()
all_regulon <- list.files(path = workdir,pattern = "._bic.regulon.txt$")
exp_file <- read.table("2018111445745_raw_expression.txt",stringsAsFactors = F,header = T,check.names = F)


i=j=k=1
generate_name <- function(df){
  genes <- regulon_file
  for (i in 1:ncol(genes)) {
    name <- colnames(genes)[i]
    result <- genes(EnsDb.Hsapiens.v86, filter=list(GeneIdFilter(as.character(genes[,i]))), 
                    return.type="data.frame", columns=c("gene_name"))
  }
}


#result <- genes(EnsDb.Hsapiens.v86, filter=list(GeneIdFilter(rownames(exp_file))), return.type="data.frame", columns=c("gene_name"))


heat_matrix <- data.frame(matrix(ncol = ncol(exp_file), nrow = 0))
colnames(heat_matrix) <- colnames(exp_file)
#final_list <- list()
#final_matrix  <- matrix()

i=1
#index_gene_name<-index_cell_type <- vector()
regulon_gene <- data.frame()
for (i in 1:length(all_regulon)) {
  heat_matrix <- data.frame(matrix(ncol = ncol(exp_file), nrow = 0))
  colnames(heat_matrix) <- colnames(exp_file)
  regulon_file <- read.table(all_regulon[i],header = F,fill = T,row.names = 1)
  gene <- as.character(sapply(regulon_file, as.character))
  gene <- unique(tmp[tmp!=""])
  regulon_gene <- rbind(regulon_gene,as.data.frame(tmp))
}
regulon_gene<- unique(regulon_gene)
gene_result <- genes(EnsDb.Hsapiens.v86, filter=list(GeneIdFilter(as.character(regulon_gene[,1]))), 
                     return.type="data.frame", columns=c("gene_name"))[,1]
heat_matrix <- subset(exp_file,rownames(exp_file) %in% gene_result)

write.table(heat_matrix,"main_heat_matrix.txt",quote = F,sep = "\t")
