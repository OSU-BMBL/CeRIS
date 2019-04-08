#######  Combine all bbc results for clustergrammer input ##########


library(magic)
library(Matrix)
library(reshape2)
library(rlist)
library(dplyr)
library(stringr)

args <- commandArgs(TRUE)

srcDir <- args[1]
jobid <- args[2]
label_use_sc3 <- args[3]
#setwd("/home/www/html/iris3/data/20190406223453")
#setwd("d:/Users/flyku/Documents/IRIS3-data/test_heatmap")
#srcDir <- getwd()
#jobid <-20190406223453
#label_use_sc3 <- 0
setwd(srcDir)
getwd()
workdir <- getwd()
dir.create('heatmap',showWarnings = F)
sort_dir <- function(dir) {
  tmp <- sort(dir)
  split <- strsplit(tmp, "_CT_") 
  split <- as.numeric(sapply(split, function(x) x <- sub("_bic.*", "", x[2])))
  return(tmp[order(split)])
}
all_regulon <- sort_dir(list.files(path = workdir,pattern = "._bic.regulon_gene_name.txt$"))
all_label <- sort_dir(list.files(path = workdir,pattern = ".+cell_label.txt$")[1])
label_file <- read.table(all_label,header = T)
exp_file <- read.table(paste(jobid,"_raw_expression.txt",sep = ""),stringsAsFactors = F,header = T,check.names = F)
#exp_file<- read.delim(paste(jobid,"_raw_expression.txt",sep = ""),check.names = FALSE, header=TRUE,row.names = 1)

short_dir <- grep("*_bic$",list.dirs(path = workdir,full.names = F),value=T) 
short_dir <- sort_dir(short_dir)
module_type <- sub(paste(".*",jobid,"_ *(.*?) *_.*",sep=""), "\\1", short_dir)

exp_file <- log1p(exp_file)
exp_file <- exp_file - rowMeans(exp_file)
user_label_name <- read.table(paste(jobid,"_user_label_name.txt",sep = ""),stringsAsFactors = F,header = F,check.names = F)
i=j=k=1
#i=2
#j=19

combine_regulon_label<-list()

#index_gene_name<-index_cell_type <- vector()
regulon_gene <- data.frame()
regulon_label_index <- 1
gene <- character()
if (label_use_sc3 == 0 | label_use_sc3 == 1 ) {
  category <- paste("SC3 label:",paste("_",label_file[,2],"_",sep=""),sep = " ")
} else {
  category <- paste("User's label:",paste("_",as.character(unlist(user_label_name)),"_",sep=""),sep = " ")
}
total_ct <- length(which(module_type=="CT"))
for (i in 1:length(all_regulon)) {
  regulon_file_obj <- file(all_regulon[i],"r")
  regulon_file_line <- readLines(regulon_file_obj)
  close(regulon_file_obj)
  regulon_file <- strsplit(regulon_file_line,"\t")
  for (regulon_row in regulon_file) {
    tmp_gene <- regulon_row[-1]
    gene <- c(gene,tmp_gene)
  }
  gene <- unique(gene[gene!=""])
  regulon_gene <- rbind(regulon_gene,as.data.frame(gene))
  #For each regulon.txt, convert ENSG -> gene name
  name_idx <- 1
  for (j in 1:length(regulon_file)) {
    regulon_gene_name <- regulon_file[[j]][-1]
    regulon_gene_name <- regulon_gene_name[regulon_gene_name!=""]
    if(length(regulon_gene_name)>100 | length(regulon_gene_name) <=1){
      next
    }
    regulon_heat_matrix <- subset(exp_file,rownames(exp_file) %in% regulon_gene_name)
    regulon_heat_matrix <- rbind(category,regulon_heat_matrix)
    if(i <= total_ct) {
    regulon_heat_matrix_filename <- paste("heatmap/CT",i,"S-R",name_idx,".heatmap.txt",sep="")
    ct_index <- gsub(".*_CT_","",short_dir[i])
    ct_index <- as.numeric(gsub("_bic","",ct_index))
    regulon_label <- paste("CT",ct_index,"S-R",name_idx,": ",sep = "")
    ct_colnames <- label_file[which(label_file[,2]==ct_index),1]
    regulon_heat_matrix <- as.data.frame(regulon_heat_matrix[,colnames(regulon_heat_matrix) %in% ct_colnames])
    rownames(regulon_heat_matrix)[-1] <- paste("Genes:",rownames(regulon_heat_matrix)[-1],sep = " ")
    rownames(regulon_heat_matrix)[1] <- ""
    colnames(regulon_heat_matrix) <- paste("Cells:",colnames(regulon_heat_matrix),sep = " ")
    write.table(regulon_heat_matrix,regulon_heat_matrix_filename,quote = F,sep = "\t", col.names=NA)
    # if # of lines=13, clustergrammer fails. add a line break
    if(nrow(regulon_heat_matrix) == 13) {
      write('\n',file=regulon_heat_matrix_filename,append=TRUE)
    }
    #save regulon label to one list
    combine_regulon_label<-list.append(combine_regulon_label,regulon_gene_name)
    names(combine_regulon_label)[regulon_label_index] <- regulon_label
    regulon_label_index <- regulon_label_index + 1
    name_idx <- name_idx + 1
    } else {
      regulon_heat_matrix_filename <- paste("heatmap/module",i-total_ct,"-R",name_idx,".heatmap.txt",sep="")
      module_index <- i - total_ct
      regulon_label <- paste("module",module_index,"-R",name_idx,": ",sep = "")
      module_colnames <- label_file[,1]
      rownames(regulon_heat_matrix)[-1] <- paste("Genes:",rownames(regulon_heat_matrix)[-1],sep = " ")
      rownames(regulon_heat_matrix)[1] <- ""
      colnames(regulon_heat_matrix) <- paste("Cells:",colnames(regulon_heat_matrix),sep = " ")
      write.table(regulon_heat_matrix,regulon_heat_matrix_filename,quote = F,sep = "\t", col.names=NA)
      # if # of lines=14, clustergrammer fails. add a line break
      if(nrow(regulon_heat_matrix) == 14) {
        write('\n',file=regulon_heat_matrix_filename,append=TRUE)
      }
      #save regulon label to one list
      combine_regulon_label<-list.append(combine_regulon_label,regulon_gene_name)
      names(combine_regulon_label)[regulon_label_index] <- regulon_label
      regulon_label_index <- regulon_label_index + 1
      name_idx <- name_idx + 1
    }
  }
}
regulon_gene<- unique(regulon_gene)
heat_matrix <- data.frame(matrix(ncol = ncol(exp_file), nrow = 0))
heat_matrix <- subset(exp_file, rownames(exp_file) %in% as.character(regulon_gene[,1]))

#heat_matrix <- heat_matrix[,order(heat_matrix[1,])]

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
  
  if (label_use_sc3 == 0 ) {
    category <- paste("SC3 label:",paste("_",label_file[,2],"_",sep=""),sep = " ")
    file_heat_matrix <- rbind(category,file_heat_matrix)
  } else if (label_use_sc3 == 1) {
    category1 <- paste("SC3 label:",paste("_",label_file[,2],"_",sep=""),sep = " ")
    category2 <- paste("User's label:",paste("_",as.character(unlist(user_label_name)),"_",sep=""),sep = " ")
    file_heat_matrix <- rbind(category1,category2,file_heat_matrix)
  } else {
    sc3_label <- read.table(paste(jobid,"_sc3_label.txt",sep=""),header = T)
    category1 <- paste("User's label:",paste("_",as.character(unlist(user_label_name)),"_",sep=""),sep = " ")
    category2 <- paste("SC3 label:",paste("_",sc3_label[,2],"_",sep=""),sep = " ")
    file_heat_matrix <- rbind(category1,category2,file_heat_matrix)
  }

  #file_heat_matrix <- file_heat_matrix[,order(file_heat_matrix[1,])]
  #j=84
  for (j in 1:length(combine_regulon_label)) {
    if(i == as.numeric(strsplit(names(combine_regulon_label[j]), "\\D+")[[1]][-1])[1] && str_detect(names(combine_regulon_label[j]),"CT")){
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
  file_heat_matrix<- tibble::rownames_to_column(file_heat_matrix, "rowname")
  if (label_use_sc3 == 0 ) {
    file_heat_matrix[1,1:k+1] <- ""
    file_heat_matrix[1,1] <- ""
    colnames(file_heat_matrix)[1:k+1] <- ""
    colnames(file_heat_matrix)[1] <- ""
  } else {
    file_heat_matrix[1:2,1:k+1] <- ""
    file_heat_matrix[1:2,1] <- ""
    colnames(file_heat_matrix)[1:k+1] <- ""
    colnames(file_heat_matrix)[1] <- ""
  }

  write.table(file_heat_matrix,paste("heatmap/CT",i,".heatmap.txt",sep = ""),row.names = F,quote = F,sep = "\t", col.names=T)
  
}
#i=j=1
if ((length(all_regulon)-total_ct) > 0) {
  for(i in 1: (length(all_regulon)-total_ct)){
    gene_row <- character()
    this_total_regulon <- sum(str_count(names(combine_regulon_label), paste("module",i,"-R",sep="")))
    
    if (this_total_regulon >=15) {
      max_show <- 15
    } else {
      max_show <- this_total_regulon
    }
    for (j in 1:max_show) {
      this_regulon_name <- paste("module",i,"-R",j,": ",sep = "")
      gene_row <- append(gene_row,as.character(unlist(combine_regulon_label[which(names(combine_regulon_label) == this_regulon_name)])))
    }
    k=0
    gene_row <- unique(gene_row)
    file_heat_matrix <- heat_matrix[rownames(heat_matrix) %in% unique(gene_row),]
    
    if (label_use_sc3 == 0 ) {
      category <- paste("SC3 label:",paste("_",label_file[,2],"_",sep=""),sep = " ")
      file_heat_matrix <- rbind(category,file_heat_matrix)
    } else if (label_use_sc3 == 1) {
      category1 <- paste("SC3 label:",paste("_",label_file[,2],"_",sep=""),sep = " ")
      category2 <- paste("User's label:",paste("_",as.character(unlist(user_label_name)),"_",sep=""),sep = " ")
      file_heat_matrix <- rbind(category1,category2,file_heat_matrix)
    } else {
      sc3_label <- read.table(paste(jobid,"_sc3_label.txt",sep=""),header = T)
      category1 <- paste("User's label:",paste("_",as.character(unlist(user_label_name)),"_",sep=""),sep = " ")
      category2 <- paste("SC3 label:",paste("_",sc3_label[,2],"_",sep=""),sep = " ")
      file_heat_matrix <- rbind(category1,category2,file_heat_matrix)
    }
    
    #file_heat_matrix <- file_heat_matrix[,order(file_heat_matrix[1,])]
    
    for (j in 1:length(combine_regulon_label)) {
      if(i == as.numeric(strsplit(names(combine_regulon_label[j]), "\\D+")[[1]][-1])[1] && str_detect(names(combine_regulon_label[j]),"module")){
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
    file_heat_matrix<- tibble::rownames_to_column(file_heat_matrix, "rowname")
    if (label_use_sc3 == 0 ) {
      file_heat_matrix[1,1:k+1] <- ""
      file_heat_matrix[1,1] <- ""
      colnames(file_heat_matrix)[1:k+1] <- ""
      colnames(file_heat_matrix)[1] <- ""
    } else {
      file_heat_matrix[1:2,1:k+1] <- ""
      file_heat_matrix[1:2,1] <- ""
      colnames(file_heat_matrix)[1:k+1] <- ""
      colnames(file_heat_matrix)[1] <- ""
    }
    
    write.table(file_heat_matrix,paste("heatmap/module",i,".heatmap.txt",sep = ""),row.names = F,quote = F,sep = "\t", col.names=T)
  }
}

#rownames(heat_matrix)[-1] <- paste("Gene:",rownames(heat_matrix)[-1],sep = " ")
#colnames(heat_matrix) <- paste("Cell:",colnames(heat_matrix),sep = " ")

