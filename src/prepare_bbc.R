#######  Read all motif result, convert to input for BBC ##########
# remove all empty files before this
 
library(seqinr)
library(tidyverse)
args <- commandArgs(TRUE)
#setwd("D:/Users/flyku/Documents/IRIS3-data/test_meme_new")
#setwd("/home/www/html/iris3_test/data/20190408202315/")
#srcDir <- getwd()
#jobid <-20190408202315 
# is_meme <- 0
# motif_len <- 12
srcDir <- args[1]
is_meme <- args[2] # no 0, yes 1
motif_len <- args[3]
setwd(srcDir)
getwd()
workdir <- getwd()
alldir <- list.dirs(path = workdir)
alldir <- grep(".+_bic$",alldir,value=T)
#gene_info <- read.table("file:///D:/Users/flyku/Documents/IRIS3_data_backup/dminda/human_gene_start_info.txt")
species_id <-  as.character(read.table("species.txt"))
if(species_id == "52"){
  gene_info <- read.table("/home/www/html/iris3/program/dminda/human_gene_start_info.txt")
} else if (species_id == "53"){
  gene_info <- read.table("/home/www/html/iris3/program/dminda/mouse_gene_start_info.txt")
}

sort_dir <- function(dir) {
  tmp <- sort(dir)
  split <- strsplit(tmp, "_CT_") 
  split <- as.numeric(sapply(split, function(x) x <- sub("_bic.*", "", x[2])))
  return(tmp[order(split)])
}

sort_closure <- function(dir){
  tmp <- sort(dir)
  split <- strsplit(tmp, "/bic") 
  split <- as.numeric(sapply(split, function(x) x <- sub("\\D+", "", x[2])))
  return(tmp[order(split)])
}

sort_short_closure <- function(dir){
  tmp <- sort(dir)
  split <- strsplit(tmp, "bic") 
  split <- as.numeric(sapply(split, function(x) x <- sub("\\D+", "", x[2])))
  return(tmp[order(split)])
}

alldir <- sort_dir(alldir)
#convert_motif(all_closure[1])
#filepath<-all_closure[1]

convert_motif <- function(filepath){
  this_line <- data.frame()
  motif_file <- file(filepath,"r")
  line <- readLines(motif_file)
  # get pvalue and store it in pval_rank
  split_line <- unlist(strsplit(line," "))
  pval_value <- split_line[which(split_line == "Pvalue:")+2]
  if(length(pval_value)>0){
    pval_value <- as.numeric(gsub("\\((.+)\\)","\\1",pval_value))
    pval_name <- paste(">",basename(filepath),"-",seq(1:length(pval_value)),sep="")
    tmp_pval_df <- data.frame(pval_name,pval_value)
    #print(tmp_pval_df)
    pval_rank <<-rbind(pval_rank,tmp_pval_df)
  df <- line[substr(line,0,1) == ">"]
  df <- read.table(text=df,sep = "\t")
  colnames(df) <- c("MotifNum","Seq","start","end","Motif","Score","Info")
  }
  close(motif_file)
  return(df)
}
#i=1
#filepath=all_closure[1]
convert_meme <- function(filepath){
  this_line <- matrix(0,ncol = 6)
  this_line <- data.frame(this_line)
  motif_result <- tibble()
  line<-0
  motif_file <- file(filepath,"r")
  line = readLines(motif_file)
  close(motif_file)
  if (nchar(line[1]) != 57) {
    df <- line[substr(line,0,3) == "ENS"|substr(line,0,3) == "ens"]
    for (i in 1:length(df)) {
      this_line <- strsplit(df[i],"\\s+")[[1]]
      
      if(length(grep(".+[ATCG]",this_line[5])) == 1){
        tmp_bind <- t(data.frame(this_line))
        if(ncol(tmp_bind) < 6) {
          if (nchar(as.character(tmp_bind[5])) < motif_len){
            tmp_bind <- cbind(tmp_bind,"A")
            tmp <- tmp_bind[4]
            tmp_bind[4] <- tmp_bind[5]
            tmp_bind[5] <- tmp
          } else {
            tmp_bind <- cbind(tmp_bind,"A")
          }
        }
        motif_result <- rbind(motif_result,tmp_bind)
      }
    }
    
    df_info = line[substr(line,0,5) == "MOTIF"]
    all_motif_index <- 1
    #filepath=paste(filepath,".test",sep = "")
    cat("", file=filepath)
    #i=1
    for (i in 1:length(df_info)) {
      this_info <- strsplit(df_info[i],"\\s+")[[1]]
      this_consensus <- this_info[2]
      this_index <- i
      this_motif_length <- this_info[6]
      this_num_sites <- as.numeric(this_info[9])
      this_pval <- this_info[15]
      this_pval <- as.numeric(this_pval)
      motif_idx_range <- seq(all_motif_index,all_motif_index + this_num_sites - 1)
      all_motif_index <- all_motif_index + this_num_sites
      this_motif_align <- motif_result[motif_idx_range,]
      this_motif_name <- paste(">Motif-",i,sep = "")
      this_motif_align <- cbind(this_motif_align,this_motif_name)
      this_motif_align[,4] <- as.numeric(as.character(this_motif_align[,2])) + as.numeric(this_motif_length) - 1
      this_seq_idx <- sample(seq(1:this_num_sites))
      this_motif_align[,6] <- this_seq_idx
      colnames(this_motif_align) <- (c("V1","V2","V3","V4","V5","V6","V7"))
      this_motif_align <- this_motif_align[,c(7,6,2,4,5,3,1)]
      this_motif_align[, ] <- lapply(this_motif_align[, ], as.character)
      cat("*********************************************************\n", file=filepath,append = T)
      cat(paste(" Candidate Motif   ",this_index,sep=""), file=filepath,append = T)
      cat("\n*********************************************************\n\n", file=filepath,append = T)
      cat(paste(" Motif length: ",this_motif_length,"\n Motif number: ",this_num_sites,
                "\n Motif Pvalue: ",1/this_pval," ",this_pval,"\n\n",sep=""), file=filepath,append = T)
      cat(paste("\n------------------- Consensus sequences------------------\n",this_consensus,"\n\n",sep=""), file=filepath,append = T)
      cat("------------------- Aligned Motif ------------------\n#Motif	Seq	start	end	Motif		Score	Info\n", file=filepath,append = T)
      for (j in 1:nrow(this_motif_align)) {
        cat( as.character(this_motif_align[j, ]), file=filepath,append = T,sep = "\t")
        cat("\n", file=filepath,append = T)
      }
      cat("----------------------------------------------------\n\n", file=filepath,append = T)
    }
  }
}

#i=1
#j=19
#info = "bic1.txt.fa.closures-1"  
module_type <- sub(paste(".*_ *(.*?) *_.*",sep=""), "\\1", alldir)
#module_type <- rep("CT",6)
regulon_idx_module <- 0
result_gene_pos <- data.frame()
for (i in 1:length(alldir)) {
  combined_seq <- data.frame()
  combined_gene <- data.frame()
  pval_rank <- data.frame()
  all_closure <- list.files(alldir[i],pattern = "*.closures$",full.names = T)
  short_all_closure <- list.files(alldir[i],pattern = "*.closures$",full.names = F)
  all_closure <- sort_closure(all_closure)
  short_all_closure <- sort_short_closure(short_all_closure)
  if(length(all_closure) > 0){
    for (j in 1:length(all_closure)) {
      if(is_meme == 1) {
        convert_meme(all_closure[j])
      }
      matches <- regmatches(short_all_closure[j], gregexpr("[[:digit:]]+", short_all_closure[j]))
      bic_idx <- as.numeric(unlist(matches))
      #test
      #motif_seq <- convert_motif(paste(all_closure[j],".test",sep = ""))[,c(1,5,7)]
      motif_seq <- convert_motif(all_closure[j])[,c(1,5,7)]
      motif_pos <- convert_motif(all_closure[j])[,c(1,2,3,4,7)]
      gene_pos <- merge(motif_pos,gene_info,by.x = "Info",by.y = 'V2')
      gene_pos <-transform(gene_pos, min = pmin(start, end), max=pmax(start,end))
      gene_pos[,4] <-  gene_pos[,7] + gene_pos[,8]
      gene_pos[,5] <-  gene_pos[,7] + gene_pos[,9]
      gene_pos[,10] <- module_type[i]
      gene_pos[,11] <- paste(i,bic_idx,sub(">Motif-","",gene_pos[,2]),sep = ",")
      if(module_type[i] == "module"){
        regulon_idx_module <- regulon_idx_module + 1
        gene_pos[,11] <- paste(regulon_idx_module,bic_idx,sub(">Motif-","",gene_pos[,2]),sep = ",")
      }
      #write.table(gene_pos[,c(6,4,5,1)],paste(alldir[i],"/bic",j,".bed",sep=""),sep = "\t" ,quote=F,row.names = F,col.names = F)
      result_gene_pos <- rbind(result_gene_pos,gene_pos[,c(6,4,5,1,10,11)])
      motif_seq[,1] <- gsub(">Motif","",motif_seq[,1])
      motif_seq[,4] <- as.factor(paste(short_all_closure[j],motif_seq[,1],sep=""))
      seq_file <- motif_seq[,c(4,3)]
      motif_seq <- motif_seq[,c(4,2)]
      colnames(motif_seq) <- c("info","seq")
      colnames(seq_file) <- c("info","genes")
      combined_seq <- rbind(combined_seq,motif_seq)
      combined_gene <- rbind(combined_gene,seq_file)
      res <- paste(alldir[i],".bbc.txt",sep="")
      #res <- file("filename", "w")
      cat("", file=res)
      for (info in levels(combined_seq[,1])) {
        cat(paste(">",as.character(info),sep=""), file=res,sep="\n",append = T)
        if (length(as.character(combined_seq[which(combined_seq[,1]== info),2])) >= 100) {
          sequence <- as.character(combined_seq[which(combined_seq[,1]== info),2])[1:99]
        } else {
          sequence <- as.character(combined_seq[which(combined_seq[,1]== info),2])
        }
        cat(sequence, file=res,sep="\n",append = T)
      }
    }
  } else {
    cat("", file= paste(alldir[i],".bbc.txt",sep=""),sep="\n",append = T)
  }
  write.table(combined_gene,paste(alldir[i],".motifgene.txt",sep=""),sep = "\t" ,quote=F,row.names = F,col.names = T)

  pval_rank <- pval_rank[!duplicated(pval_rank$pval_name),]
  #test_pval_rank <- pval_rank[!duplicated(pval_rank$pval_name),] 
  if(nrow(pval_rank) > 0){
  pval_rank[,3] <- seq(1:nrow(pval_rank))
  pval_rank <- pval_rank[order((pval_rank$pval_value),decreasing = T),] 
  pval_idx <- pval_rank[,3]
  #write.table(pval_rank,paste(alldir[i],".pval.txt",sep=""),sep = "\t" ,quote=F,row.names = F,col.names = F)
  this_fasta <- read.fasta(paste(alldir[i],".bbc.txt",sep=""))
  this_fasta <- this_fasta[pval_idx]
  write.fasta(this_fasta,names(this_fasta),paste(alldir[i],".bbc.txt",sep=""),nbchar = 12)
  }
  cat(">end", file=paste(alldir[i],".bbc.txt",sep=""),sep="\n",append = T)
}

write.table(result_gene_pos,paste("motif_position.bed",sep=""),sep = "\t" ,quote=F,row.names = F,col.names = F)


