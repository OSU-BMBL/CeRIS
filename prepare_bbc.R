#######  Read all motif result, convert to input for BBC ##########
# remove all empty files before this

library(stringr)
library(tidyverse)
library(seqinr)

args <- commandArgs(TRUE)
jobid <- args[1] # jobid
#outFile <- args[2] # user job id

workdir <- getwd()
alldir <- list.dirs(path = workdir)
alldir <- grep("*_bic",alldir,value=T)


filepath = get_dir_motif(alldir[1])[1]
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
i=1
j=1
  
for (i in 1:length(alldir)) {
  combined_seq <- data.frame()
  all_closure <- list.files(alldir[i],pattern = "*.closures",full.names = T)
  short_all_closure <- list.files(alldir[i],pattern = "*.closures",full.names = F)
  for (j in 1:length(all_closure)) {
    motif_seq <- convert_motif(all_closure[j])[,c(1,5,7)]
    motif_seq[,1] <- gsub(">Motif","",motif_seq[,1])
    motif_seq[,4] <- as.factor(paste(short_all_closure[j],motif_seq[,1],sep=""))
    seq_file <- motif_seq[,c(4,3)]
    motif_seq <- motif_seq[,c(4,2)]
    colnames(motif_seq) <- c("info","seq")
    colnames(seq_file) <- c("info","genes")
    write.table(seq_file,paste(alldir[i],".motifgene.txt",sep=""),sep = "\t" ,quote=F,row.names = F,col.names = T)
    combined_seq <- rbind(combined_seq,motif_seq)
    res <- paste(alldir[i],".bbc.txt",sep="")
    #res <- file("filename", "w")
    cat("", file=res)
    for (info in levels(combined_seq[,1])) {
      cat(paste(">",as.character(info),sep=""), file=res,sep="\n",append = T)
      sequence <- as.character(combined_seq[which(combined_seq[,1]== info),2])
      cat(sequence, file=res,sep="\n",append = T)
    }
  }
  cat(">end", file=res,sep="\n",append = T)
}



