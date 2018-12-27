#######  Combine all bbc results for clustergrammer input ##########


library(magic)
library(Matrix)
library(reshape2)
library(rlist)
args <- commandArgs(TRUE)

srcDir <- args[1]
jobid <- args[2]
#setwd("D:/Users/flyku/Documents/IRIS3-data/test_regulon")
#srcDir <- getwd()
#jobid <-2018122223516 
srcDir <- args[1]
jobid <- args[2]
setwd(srcDir)
getwd()
workdir <- getwd()
dir.create('heatmap')

all_regulon <- list.files(path = workdir,pattern = "._bic.regulon_gene_name.txt$")
all_label <- list.files(path = workdir,pattern = ".+cell_label.txt$")[1]
label_file <- read.table(all_label,header = T)
exp_file <- read.table(paste(jobid,"_raw_expression.txt",sep = ""),stringsAsFactors = F,header = T,check.names = F)

short_dir <- grep("*_bic$",list.dirs(path = workdir,full.names = F),value=T) 
exp_file <- log1p(exp_file) - log1p(rowMeans(exp_file))

i=j=k=1
#i=4

combine_regulon_label<-list()

#index_gene_name<-index_cell_type <- vector()
regulon_gene <- data.frame()
regulon_label_index <- 1
category <- paste("Cell Type:",paste("_",label_file[,2],"_",sep=""),sep = " ")
for (i in 1:length(all_regulon)) {
  regulon_file <- read.table(all_regulon[i],header = F,fill = T,row.names = 1)
  gene <- as.character(sapply(regulon_file, as.character))
  gene <- unique(gene[gene!=""])
  regulon_gene <- rbind(regulon_gene,as.data.frame(gene))
  #For each regulon.txt, convert ENSG -> gene name
  name_idx <- 1
  for (j in 1:nrow(regulon_file)) {
    
    regulon_gene_name <- as.character(unlist(regulon_file[j,]))
    regulon_gene_name <- regulon_gene_name[regulon_gene_name!=""]
    if(length(regulon_gene_name)>100 | length(regulon_gene_name) <1){
      next
    }
    
    regulon_heat_matrix_filename <- paste("heatmap/",gsub("_bic","",short_dir[i]),"_regulon",name_idx,".heatmap.txt",sep="")
    regulon_heat_matrix <- subset(exp_file,rownames(exp_file) %in% regulon_gene_name)
    regulon_heat_matrix <- rbind(category,regulon_heat_matrix)
    
    ct_index <- gsub(".*_CT_","",short_dir[i])
    ct_index <- as.numeric(gsub("_bic","",ct_index))
    regulon_label <- paste("CT",ct_index,"S-R",name_idx,": ",sep = "")
    ct_colnames <- label_file[which(label_file[,2]==ct_index),1]
    regulon_heat_matrix <- regulon_heat_matrix[,colnames(regulon_heat_matrix) %in% ct_colnames]
    rownames(regulon_heat_matrix)[-1] <- paste("Genes:",rownames(regulon_heat_matrix)[-1],sep = " ")
    rownames(regulon_heat_matrix)[1] <- ""
    colnames(regulon_heat_matrix) <- paste("Cells:",colnames(regulon_heat_matrix),sep = " ")
    write.table(regulon_heat_matrix,regulon_heat_matrix_filename,quote = F,sep = "\t", col.names=NA)
    #save regulon label to one list
    combine_regulon_label<-list.append(combine_regulon_label,regulon_gene_name)
    names(combine_regulon_label)[regulon_label_index] <- regulon_label
    regulon_label_index <- regulon_label_index + 1
    name_idx <- name_idx + 1
  }
}
regulon_gene<- unique(regulon_gene)
category <- paste("Cell Type:",paste("_",label_file[,2],"_",sep=""),sep = " ")

heat_matrix <- data.frame(matrix(ncol = ncol(exp_file), nrow = 0))
heat_matrix <- subset(exp_file, rownames(exp_file) %in% as.character(regulon_gene[,1]))
heat_matrix <- rbind(category,heat_matrix)
heat_matrix <- heat_matrix[,order(heat_matrix[1,])]
category <- as.character(heat_matrix[1,])
rownames(heat_matrix)[1] <- ""
#i=j=1 
# get CT#-regulon1-# heat matrix
for(i in 1: length(unique(label_file[,2]))){
  gene_row <- character()
  this_total_regulon <- 0
  for (m in length(combine_regulon_label):1) {
    if(i == as.numeric(strsplit(names(combine_regulon_label[m]), "\\D+")[[1]][-1])[1]){
      
      this_regulon_num <- as.numeric(strsplit(names(combine_regulon_label[m]), "\\D+")[[1]][-1])[2]
      if (this_regulon_num > this_total_regulon) {
        this_total_regulon <- this_regulon_num
      }
    }
  }
  if (this_total_regulon >=15) {
    max_show <- 15
  } else {
    max_show <- this_total_regulon
  }
  for (j in 1:max_show) {
    this_regulon_name <- paste("CT",i,"S-R",j,": ",sep = "")
    gene_row <- append(gene_row,as.character(unlist(combine_regulon_label[which(names(combine_regulon_label) == this_regulon_name)])))
  }
  k=0
  gene_row <- unique(gene_row)
  file_heat_matrix <- heat_matrix[rownames(heat_matrix) %in% unique(gene_row),]
  file_heat_matrix <- rbind(category,file_heat_matrix)
  for (j in 1:length(combine_regulon_label)) {
    if(i == as.numeric(strsplit(names(combine_regulon_label[j]), "\\D+")[[1]][-1])[1]){
      regulon_label_col <- as.data.frame(paste(names(combine_regulon_label[j]),(rownames(file_heat_matrix) %in% unlist(combine_regulon_label[j]) )*1,sep = ""),stringsAsFactors=F)
      #print(regulon_label_col)
      #regulon_label_col[1,1] <- ""
      file_heat_matrix <- cbind(regulon_label_col,file_heat_matrix)
      k <- k + 1
      if(k>=15){
        #file_heat_matrix <- file_heat_matrix[,-15]
        break
      }
    }
  }
  file_heat_matrix[1,1:k] <- ""
  rownames(file_heat_matrix)[1] <- ""
  colnames(file_heat_matrix)[1:k] <- ""
  write.table(file_heat_matrix,paste("heatmap/CT",i,".heatmap.txt",sep = ""),quote = F,sep = "\t", col.names=NA)
  
}
#rownames(heat_matrix)[-1] <- paste("Gene:",rownames(heat_matrix)[-1],sep = " ")
#colnames(heat_matrix) <- paste("Cell:",colnames(heat_matrix),sep = " ")

