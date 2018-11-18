####### preprocessing expression matrix based on SC3 ##########

library(data.table)
#removes genes/transcripts that are either expressed (expression value > 2) in less than X% of cells (rare genes/transcripts) 
#or expressed (expression value > 0) in at least (100 ??? X)% of cells (ubiquitous genes/transcripts). 
#By default, X is set at 6.
args <- commandArgs(TRUE)
srcFile <- args[1] # raw user filename
outFile <- args[2] # user job id
delim <- args[3] #delimiter
# srcFile = "C:/Users/flyku/Desktop/Yan_expression.csv"
# srcFile = "/home/www/html/iris3/program/test_yan.csv";
# outFile <- "1103"
# delim <- ","

#yan.test <- read.csv("Goolam_cell_label.csv",header=T,sep=",",check.names = FALSE, row.names = 1)
getwd()
yan.test <- read.delim(srcFile,header=T,sep=delim,check.names = FALSE, row.names = 1)

nrare <- ncol(yan.test) * 0.06
nubi <- ncol(yan.test) * 0.94
new_yan <- data.frame()
filter_func <- function(this){
  if(length(which(this>2)) >= nrare && length(which(this==0)) <= nubi){
    return (1)
  } else {
    return (0)
  }
}

new_yan_index <- as.vector(apply(yan.test, 1, filter_func))
new_yan <- yan.test[which(new_yan_index == 1),]

new_yan <- log1p(new_yan)
filter_num <- nrow(yan.test)-nrow(new_yan)
filter_rate <- formatC(filter_num/nrow(yan.test),digits = 2)

write.table(cbind(filter_num,filter_rate), paste(outFile,"_filtered_rate.txt",sep = ""),sep = "\t", row.names = F,col.names = F,quote = F)
write.table(yan.test,paste(outFile,"_raw_expression.txt",sep = ""), row.names = T,col.names = T,sep="\t",quote=FALSE)
write.table(new_yan,paste(outFile,"_filtered_expression.txt",sep = ""), row.names = T,col.names = T,sep="\t",quote=FALSE)
#write.table(yan.test,"Goolam_cell_label.txt",sep="\t")
#write.csv(new_yan,"Goolam_expression_filtered.csv")










