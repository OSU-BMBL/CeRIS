#######  Combine all bbc results for clustergrammer input ##########


library(GenomicAlignments)
library(ensembldb)
library(EnsDb.Hsapiens.v86)
library(magic)
library(Matrix)
library(reshape2)
library(rlist)
args <- commandArgs(TRUE)

srcDir <- args[1]

getwd()

setwd("D:/Users/flyku/Documents/IRIS3-R/data")
workdir <- getwd()
all_regulon <- list.files(path = workdir,pattern = "._bic.regulon.txt$")
exp_file <- read.table("2018111445745_raw_expression.txt",stringsAsFactors = F,header = T,check.names = F)
label_file <- read.table("2018111413246_cell_label.txt",stringsAsFactors = F,header = T,check.names = F)
short_dir <- grep("*_bic$",list.dirs(path = workdir,full.names = F),value=T) 

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

i=j=1
combine_regulon_label<-list()
#index_gene_name<-index_cell_type <- vector()
regulon_gene <- data.frame()
regulon_label_index <- 1
for (i in 1:length(all_regulon)) {
  heat_matrix <- data.frame(matrix(ncol = ncol(exp_file), nrow = 0))
  colnames(heat_matrix) <- colnames(exp_file)
  regulon_file <- read.table(all_regulon[i],header = F,fill = T,row.names = 1)
  gene <- as.character(sapply(regulon_file, as.character))
  gene <- unique(gene[gene!=""])
  regulon_gene <- rbind(regulon_gene,as.data.frame(gene))
  res <- paste(short_dir[i],".regulon_genename.txt",sep="")
  cat("",file=res)
  #For each regulon.txt, convert ENSG -> gene name
  regulon_file <- t(regulon_file)
  for (j in 1:ncol(regulon_file)) {
    regulon_idx <- colnames(regulon_file)[j]
    regulon_genename <- genes(EnsDb.Hsapiens.v86, filter=list(GeneIdFilter(as.character(regulon_file[,j]))), 
                              return.type="data.frame", columns=c("gene_name"))[,1] 
    for (k in 1:length(regulon_genename)) {
      regulon_file[k,j] <- regulon_genename[k]
    }
    cat(paste(j,"\t",sep = ""),file=res,sep = "",append = T)
    cat(paste(regulon_genename,"\t",sep = ""),file=res,append = T)
    cat("\n",file=res,append = T)
    regulon_heat_matrix_filename <- paste(short_dir[i],".regulon",j,".heatmap.txt",sep="")
    regulon_heat_matrix <- subset(exp_file,rownames(exp_file) %in% regulon_genename)

    category <- paste("Cell Type:",label_file[,2],sep = " ")
    regulon_heat_matrix <- rbind(category,regulon_heat_matrix)
    ct_index <- gsub(".*_CT_","",short_dir[i])
    ct_index <- as.numeric(gsub("_bic","",ct_index))
    regulon_label <- paste("CT",ct_index,"Regulon",j,": ",sep = "")
    ct_colnames <- label_file[which(label_file[,2]==ct_index),1]
    regulon_heat_matrix <- regulon_heat_matrix[,colnames(regulon_heat_matrix) %in% ct_colnames]
    rownames(regulon_heat_matrix)[-1] <- paste("Genes:",rownames(regulon_heat_matrix)[-1],sep = " ")
    rownames(regulon_heat_matrix)[1] <- ""
    colnames(regulon_heat_matrix) <- paste("Cells:",colnames(regulon_heat_matrix),sep = " ")
    write.table(regulon_heat_matrix,regulon_heat_matrix_filename,quote = F,sep = "\t", col.names=NA)
    #save regulon label to one list
    tmp_label_name <- as.character(regulon_file[,j])
    tmp_label_name <- tmp_label_name[tmp_label_name!=""]
    combine_regulon_label<-list.append(combine_regulon_label,tmp_label_name)
    names(combine_regulon_label)[regulon_label_index] <- regulon_label
    regulon_label_index <- regulon_label_index + 1
  }
  
  regulon_file <- t(regulon_file)
  regulon_file[regulon_file==""] <- NA

}
regulon_gene<- unique(regulon_gene)
gene_result <- genes(EnsDb.Hsapiens.v86, filter=list(GeneIdFilter(as.character(regulon_gene[,1]))), 
                     return.type="data.frame", columns=c("gene_name"))[,1]
heat_matrix <- subset(exp_file,rownames(exp_file) %in% gene_result)

category <- paste("Cell Type:",label_file[,2],sep = " ")

heat_matrix <- rbind(category,heat_matrix)
rownames(heat_matrix)[1] <- ""

for(i in length(combine_regulon_label):1){
  regulon_label_col <- as.data.frame(paste(names(combine_regulon_label[i]),(rownames(heat_matrix) %in% unlist(combine_regulon_label[i]) )*1,sep = ""),stringsAsFactors=F)
  regulon_label_col[1,1] <- ""
  heat_matrix <- cbind(regulon_label_col,heat_matrix)
}
colnames(heat_matrix)[1:length(combine_regulon_label)] <- ""
#rownames(heat_matrix)[-1] <- paste("Gene:",rownames(heat_matrix)[-1],sep = " ")
#colnames(heat_matrix) <- paste("Cell:",colnames(heat_matrix),sep = " ")

write.table(heat_matrix,"2018111413246_heatmap_matrix.txt",quote = F,sep = "\t", col.names=NA)
