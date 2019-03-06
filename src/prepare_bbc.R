#######  Read all motif result, convert to input for BBC ##########
# remove all empty files before this

library(stringr)
library(tidyverse)

args <- commandArgs(TRUE)
#setwd("D:/Users/flyku/Documents/IRIS3-data/test_meme")
#srcDir <- getwd()
#jobid <-2018122833236 
# is_meme <- 1
# motif_len <- 12
srcDir <- args[1]
is_meme <- args[2] # no 0, yes 1
motif_len <- args[3]
setwd(srcDir)
getwd()
workdir <- getwd()
alldir <- list.dirs(path = workdir)
alldir <- grep(".+_bic$",alldir,value=T)
sort_dir <- function(dir) {
  tmp <- sort(dir)
  split <- strsplit(tmp, "_CT_") 
  split <- as.numeric(sapply(split, function(x) x <- sub("_bic.*", "", x[2])))
  return(tmp[order(split)])
}
alldir <- sort_dir(alldir)
#convert_motif(all_closure[1])
convert_motif <- function(filepath){
  this_line <- data.frame()
  motif_file <- file(filepath,"r")
  line = readLines(motif_file)
  df <- line[substr(line,0,1) == ">"]
  df <- read.table(text=df,sep = "\t")
  colnames(df) <- c("MotifNum","Seq","start","end","Motif","Score","Info")
  close(motif_file)
  return(df)
}
#i=38
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
                "\n Motif Pvalue: ",this_pval,"\n\n",sep=""), file=filepath,append = T)
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

#i=3
#j=44
#info = "bic1.txt.fa.closures-1"  
for (i in 1:length(alldir)) {
  combined_seq <- data.frame()
  combined_gene <- data.frame()
  all_closure <- list.files(alldir[i],pattern = "*.closures$",full.names = T)
  short_all_closure <- list.files(alldir[i],pattern = "*.closures$",full.names = F)
  for (j in 1:length(all_closure)) {
    if(is_meme == 1) {
      convert_meme(all_closure[j])
    }
    #test
    #motif_seq <- convert_motif(paste(all_closure[j],".test",sep = ""))[,c(1,5,7)]
    motif_seq <- convert_motif(all_closure[j])[,c(1,5,7)]
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
  cat(">end", file=res,sep="\n",append = T)
  write.table(combined_gene,paste(alldir[i],".motifgene.txt",sep=""),sep = "\t" ,quote=F,row.names = F,col.names = T)
  
}



