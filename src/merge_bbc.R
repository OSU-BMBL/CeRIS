#######  Read [MotifNum,Genes], [Motif-Motif Similarity], convert to combined[Motif-Genes] ##########
# input: 
#1. Motif-Genes table from prepare_bbc.R
#2. BBC motif cluster
#output: regulon
library(seqinr)
args <- commandArgs(TRUE)
srcDir <- args[1]
setwd(srcDir)
getwd()
workdir <- getwd()
alldir <- list.dirs(path = workdir)
alldir <- grep("*_bic$",alldir,value=T)
short_dir <- grep("*_bic$",list.dirs(path = workdir,full.names = F),value=T) 

i=j=k=m=1
k= motif_num[1]
for (i in 1:length(alldir)) {
  res <- paste(short_dir[i],".regulon.txt",sep="")
  cat("",file=res)
  cluster_filename <- paste("./bg.BBC/bg.",short_dir[i],".bbc.txt.MC",sep="")
  motif_filename <- paste(short_dir[i],".motifgene.txt",sep="")
  sequence_filename <- paste(short_dir[i],".bbc.txt",sep="")
  motif_file <- read.table(motif_filename,sep = "\t",header = T)
  cluster_file <- read.table(cluster_filename,sep = "\t",header = T)
  sequence_file <- read.fasta(sequence_filename,as.string = T)

  for (j in 1:max(cluster_file[,2])) {
    motif_num <- as.character(cluster_file[which(cluster_file[,2] == j),1])
    sequence_out_name <- paste("ct",i,"motif",j,".fa",sep = "")
    sequence_info <- character()
    genes_num <- vector()
    idx <- 1
    for (k in motif_num) {
      genes_num <- c(genes_num,which(as.character(motif_file[,1]) == k))
      sequence_info_tmp <-as.character(sequence_file[names(sequence_file) %in% motif_num][idx])
      idx <- idx + 1
      sequence_info_tmp <- gsub('(?=(?:.{14})+$)', "\n", sequence_info_tmp, perl = TRUE)
      sequence_info <- paste(sequence_info,sequence_info_tmp,sep = "")
    }
    write.table(sequence_info,sequence_out_name,col.names = F,row.names = F,quote = F)
    
    genes <- motif_file[genes_num,2]
    genes <- as.character(genes[!duplicated(genes)])
    cat(paste(j,"\t",sep = ""),file=res,append = T)
    cat(genes,file=res,sep = "\t",append = T)
    cat("\n",file=res,append = T)
  }
  
}

regulon_all_files <- list.files(path = workdir,pattern = "*bic.regulon.txt")
# get complex regulon from all regulons
combined_regulon <- data.frame()
i=2
j=1
max_column <- 0
for (i in 1:length(regulon_all_files)) {
  res <- paste(short_dir[i],".regulon.gene.txt",sep="")
  res_final <- paste(short_dir[i],".complex.regulon.txt",sep="")
  cat("",file=res)
  regulo <- readLines(regulon_all_files[i])
  combined_regulon <- read.table(text = regulo,sep = "\t",fill = T)
  all_genes <- as.character(unlist(combined_regulon[,-1]))
  all_genes <- all_genes[!duplicated(all_genes)]
  all_genes <- all_genes[all_genes!=""]
  for (j in 1:length(all_genes)) {
    belong_regulon <- sort(which(combined_regulon[,-1]==all_genes[j],arr.ind = TRUE)[,1])
    if(length(belong_regulon) > max_column){
      max_column <- length(belong_regulon)
    }
    tmp <- data.frame(all_genes[j],t(as.data.frame(belong_regulon)))
    cat(paste(all_genes[j],"\t",sep = ""),file=res,append = T)
    cat(belong_regulon,file=res,append = T,sep = "\t")
    cat("\n",file=res,append = T)
  }
  idx<-vector()
  tmp_final <- data.frame()
  sorted_res <- read.table(res,col.names = paste0("V",seq_len(max_column+1)),header = F,fill = T,comment.char = "")
  tmp_res <- tmp_idx<- character()
  index <- unique(sorted_res[,-1])
  for (j in 1:nrow(sorted_res)) {
    tmp <- paste(sorted_res[j,-1],sep = ",",collapse = ",")
    tmp_res <- c(tmp_res,tmp)
  }
  cat("",file=res_final)
  for (j in 1:nrow(index)) {
    tmp <- paste(index[j,],sep = ",",collapse = ",")
    tmp_idx <- as.character(index[j,])
    tmp_idx <- tmp_idx[!(tmp_idx=="NA")]
    if(length(tmp_idx) !=0){
      tmp_gene <- as.character(sorted_res[which(tmp==tmp_res),1])
      cat(tmp_gene,file=res_final,append = T,sep = "\t")
      cat("\t",file=res_final,append = T)
      cat(tmp_idx,file=res_final,append = T,sep = "\t")
      cat("\n",file=res_final,append = T)
    }
  }
}



