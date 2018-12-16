#######  Calculate ARI score if user provide their cell label ##########


args <- commandArgs(TRUE)
srcFile <- args[1] # raw user filename
outFile <- args[2] # user job id
delim_array <- c("\t"," ",",") # 1-tab, 2-space, 3-comma
delim <- delim_array[as.numeric(args[3])] #delimiter
#delim <- args[3]
#setwd("C:/Users/flyku/Desktop/iris3")
# srcFile = "20181124190953_sc3_label.txt"
# outFile <- "20181124190953"
# delim <- "\t"

#install.packages("NMF")
#install.packages("clues")
#install.packages("igraph")
#install.packages("MLmetrics")
#install.packages("AUC")
#install.packages("ROSE")
#devtools::install_github("sachsmc/plotROC")
#install.packages("networkD3")
library(reader)
library(plotROC)
library("NMF")
library("clues")
library("igraph")
library("MLmetrics")
library("AUC")
library("ROSE")
library("ggplot2")
library(networkD3)
library(tidyr)
library(gdata)
library(data.table)


srcLabel <- read.delim(srcFile,header=T,sep=delim,check.names = FALSE)
sc3_cluster <- srcLabel

#2nd input
#user_label <- read.delim(srcFile,header=T,sep=delim,check.names = FALSE)
user_label_file <- read.delim(srcLabel,header=T,sep="\t",check.names = FALSE)

user_label_index <- which(colnames(user_label_file) ==  "label")
user_cellname_index <- which(colnames(user_label_file) ==  "cell_name")
user_label <- data.frame(user_label_file[,user_cellname_index],user_label_file[,user_label_index])

#test
#user_label <- data.frame(user_label_file[,user_cellname_index],user_label_file[,3])
user_label_name <- user_label[,2]
user_label[,2] <- as.factor(user_label[,2])
levels(user_label[,2]) <- 1: length(levels(user_label[,2]))

colnames(sc3_cluster) <- c("cell_name","cluster")
colnames(user_label) <- c("cell_name","label")

#write.table(sc3_cluster, paste(outFile,"_sc3_cluster.txt",sep = ""),sep = "\t", row.names = F,col.names = T,quote = F)
#write.table(user_label, paste(outFile,"_cell_label.txt",sep = ""),sep = "\t", row.names = F,col.names = T,quote = F)


# sc3_cluster <- read.delim("123456_sc3_cluster.txt",header=T,sep=" ",check.names = FALSE)
target <- merge(sc3_cluster,user_label,by.x = "cell_name",by.y = "cell_name" )


clustering_purity <- purity(as.factor(target$cluster),as.factor(target$label))
clustering_entropy <- entropy(as.factor(target$cluster),as.factor(target$label))
clustering_nmi <- igraph::compare(as.factor(target$cluster),as.factor(target$label),method="nmi")
clustering_ARI <- igraph::compare(as.factor(target$cluster),as.factor(target$label),method="adjusted.rand")
clustering_RI <-adjustedRand(as.numeric(target$cluster),as.numeric(target$label),  randMethod = "Rand")  # calculate Rand Index
clustering_JI <-adjustedRand(as.numeric(target$cluster),as.numeric(target$label),  randMethod = "Jaccard")  # calculate Jaccard
clustering_FMI <-adjustedRand(as.numeric(target$cluster),as.numeric(target$label),  randMethod = "FM")  # calculate Fowlkes Mallows Index
#clustering_F1_Score <- F1_Score(as.numeric(target$cluster),as.numeric(target$label))
#clustering_Precision <- Precision(as.factor(target$cluster),as.factor(target$label))
#clustering_Recall <- Recall(as.factor(target$cluster),as.factor(target$label))
clustering_Accuracy <- Accuracy(as.numeric(target$cluster),as.numeric(target$label))
#clustering_sensitivity <- sensitivity(as.numeric(target$cluster),as.numeric(target$label))
#clustering_specificity <- specificity(as.numeric(target$cluster),as.numeric(target$label))

res <- cbind(clustering_ARI,clustering_RI,clustering_JI,clustering_FMI,clustering_F1_Score,
             clustering_Accuracy,clustering_Precision,clustering_Recall,clustering_entropy,clustering_purity)

res_colname <- colnames(res)
res_colname <- gsub(".*\\_","",res_colname)
colnames(res) <- res_colname
write.table(res, paste(outFile,"_sc3_cluster_evaluation.txt",sep = ""),sep = "\t", row.names = F,col.names = T,quote = F)



# step2 change label names
user_label$label <- sub("^", "L", user_label$label )
sc3_cluster$cluster <- sub("^", "C", sc3_cluster$cluster )

# step3 rbind two labels to create node matrix
comb.label.list <- as.data.frame(rbind(matrix(user_label$label),matrix(sc3_cluster$cluster)))
colnames(comb.label.list) <- c("name")
comb.label.list[,1] <- as.character(comb.label.list[,1])
i=1
for (i in 1:nrow(comb.label.list)) {
  idx <- which(colnames(table(user_label_name,user_label$label)) == as.character(comb.label.list[i,1]))
  if(length(idx)==1){
    comb.label.list[i,1] <- as.character(comb.label.list[i,1])
    comb.label.list[i,1] <- as.character(rownames(table(user_label_name,user_label$label))[idx])
  }
}
comb.label.list[,1] <- as.factor(comb.label.list[,1])
# step4 give number to each label by all label groups, and extract unique nodes
map.label <- mapLevels(x=comb.label.list)
map.label <- c(unlist(map.label$name))
map.label <- map.label-1
nodes <- data.table(name=names(map.label))
nodes <- data.table(name=names(map.label))

# step5 create link matrix
links <- as.data.frame(cbind(user_label$label,sc3_cluster$cluster))
colnames(links) <- c("label","pred_label")
links <- unite(links, newcol, c(label, pred_label), remove=FALSE)
links <- aggregate(links$label~links$newcol, data=links, FUN=length)
colnames(links) <- c("type","value")
links <- separate(data = links, col = type, into = c("type1", "type2"), sep = "\\_")
i=1
for (i in 1:nrow(links)) {
  idx <- which(colnames(table(user_label_name,user_label$label)) == as.character(links[i,1]))
  if(length(idx)==1){
    links[i,1] <- as.character(links[i,1])
    links[i,1] <- as.character(rownames(table(user_label_name,user_label$label))[idx])
  }
}
# change types into numbers as map.label
links <- data.table(
  src = map.label[(links$type1)],
  target = map.label[(links$type2)],
  value = links$value
)
txtsrc <- links[, .(total = sum(value)), by=c('src')]
nodes[txtsrc$src+1L, name := paste0(name, ' (', txtsrc$total, ')')]

txttarget <- links[, .(total = sum(value)), by=c('target')]
nodes[txttarget$target+1L, name := paste0(name, ' (', txttarget$total, ')')]

# create sankey dengram use nodes and links
sankeyNetwork(Links = links, Nodes = nodes,
              Source = "src", Target = "target",
              Value = "value", NodeID = "name",
              fontSize= 12, nodeWidth =30)

# title left: cell label; right:sc3 cluster

