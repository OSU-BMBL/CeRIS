#######  Read all motif result, convert to input for BBC ##########
# remove all empty files before this

library(magic)
library(Matrix)
library(reshape2)
library(COMPASS)
library(RColorBrewer)
args <- commandArgs(TRUE)
#setwd("D:/Users/flyku/Documents/IRIS3-data/test_regulon")
#srcDir <- getwd()
#jobid <-2018122223516 
srcDir <- args[1]
jobid <- args[2]
setwd(srcDir)
getwd()
workdir <- getwd()
all_regulon <- list.files(path = workdir,pattern = "._bic.regulon_gene_name.txt$")
all_label <- list.files(path = workdir,pattern = ".+cell_label.txt$")[1]
label_file <- read.table(all_label,header = T)
exp_file <- read.table(paste(jobid,"_raw_expression.txt",sep = ""),stringsAsFactors = F,header = T,check.names = F)


i=j=k=1

#generate_name <- function(df){
#  genes <- regulon_file
#  for (i in 1:ncol(genes)) {
#    name <- colnames(genes)[i]
#    result <- genes(EnsDb.Hsapiens.v86, filter=list(GeneIdFilter(as.character(genes[,i]))), 
#                    return.type="data.frame", columns=c("gene_name"))
#  }
#}


#result <- genes(EnsDb.Hsapiens.v86, filter=list(GeneIdFilter(rownames(exp_file))), return.type="data.frame", columns=c("gene_name"))
#result <- genes(EnsDb.Hsapiens.v86, filter=list(GeneNameFilter(rownames(exp_file)),GeneIdFilter("ENSG", "startsWith")), return.type="data.frame", columns=c("gene_id"))

heat_matrix <- data.frame(matrix(ncol = nrow(label_file), nrow = 0))
colnames(heat_matrix) <- as.character(label_file[,1])
final_list <- list()
final_matrix  <- matrix()

i=1
index_gene_name<-index_cell_type <- vector()
for (i in 1:length(all_regulon)) {
  heat_matrix <- data.frame(matrix(ncol = nrow(label_file), nrow = 0))
  colnames(heat_matrix) <- as.character(label_file[,1])
  regulon_file <- read.table(all_regulon[i],header = F,fill = T,row.names = 1)
  num_cell_type <- as.numeric(sub(".*_CT_ *(.*?) *_bic.*", "\\1", all_regulon[i]))
  regulon_cell_type <- label_file[which(label_file[,2] == num_cell_type),1]
  for (j in 1:nrow(regulon_file)) {
    this_line_regulon <- as.character(unlist(regulon_file[j,]))
    regulon_gene_name <- this_line_regulon[this_line_regulon!=""]
    for (k in 1:length(regulon_gene_name)) {
      index_gene_name[k] <- which(rownames(exp_file)==regulon_gene_name[k])
    }
    for (k in 1:length(regulon_cell_type)) {
      index_cell_type[k] <- which(colnames(exp_file)==as.character(regulon_cell_type[k]))
    }
    regulon_in_exp <- exp_file[index_gene_name,index_cell_type]

    tmp_heat_matrix <- t(as.data.frame(colMeans(regulon_in_exp)))
    rownames(tmp_heat_matrix) <- paste("CT",num_cell_type,"-Regulon",j,sep = "")
    heat_matrix <- rbind(heat_matrix,tmp_heat_matrix)
    
  }
  final_list[[i]] <- as.matrix(heat_matrix)
}

final_matrix <- do.call(adiag, final_list)
final_matrix[final_matrix==0] <- NA
# block matrix
#write.table(final_matrix,"final_matrix.txt",quote = F)
heat_matrix <- data.frame(matrix(ncol = ncol(final_matrix), nrow = 0))
colnames(heat_matrix) <- colnames(final_matrix)
for (i in 1:length(all_regulon)) {

  regulon_file <- read.table(all_regulon[i],header = F,fill = T,row.names = 1)
  num_cell_type <- as.numeric(sub(".*_CT_ *(.*?) *_bic.*", "\\1", all_regulon[i]))
  regulon_cell_type <- label_file[which(label_file[,2] == num_cell_type),1]
  for (j in 1:nrow(regulon_file)) {
    regulon_gene_name <- genes(EnsDb.Hsapiens.v86, filter=list(GeneIdFilter(as.character(regulon_file[,j]))), 
                               return.type="data.frame", columns=c("gene_name"))[,1]
    for (k in 1:length(regulon_gene_name)) {
      index_gene_name[k] <- which(rownames(exp_file)==regulon_gene_name[k])
    }
    for (k in 1:length(colnames(final_matrix))) {
      index_cell_type[k] <- which(colnames(exp_file)==colnames(final_matrix)[k])
    }
    regulon_in_exp <- exp_file[index_gene_name,index_cell_type]
    
    tmp_heat_matrix <- t(as.data.frame(colMeans(regulon_in_exp)))
    rownames(tmp_heat_matrix) <- paste("CT",num_cell_type,"-Regulon",j,sep = "")
    heat_matrix <- rbind(heat_matrix,tmp_heat_matrix)
    
  }
  
  final_list[[i]] <- as.matrix(heat_matrix)
}


#p1 =ggplot(data = melt(final_list[[1]]), aes(x = Var2, y = Var1)) +
#  geom_tile(aes(fill = value)) +scale_fill_gradient(low="yellow", high="red")+ theme(axis.text.x  = element_text(angle=90, vjust=0.5, size=10))
#
#p2 =ggplot(data = melt(final_list[[2]]), aes(x = Var2, y = Var1)) +
#  geom_tile(aes(fill = value)) +scale_fill_gradient(low="yellow", high="red")+ theme(axis.text.x  = element_text(angle=90, vjust=0.5, size=10))
#
#p3 =ggplot(data = melt(final_list[[3]]), aes(x = Var2, y = Var1)) +
#  geom_tile(aes(fill = value)) +scale_fill_gradient(low="yellow", high="red")+ theme(axis.text.x  = element_text(angle=90, vjust=0.5, size=10))
#
#
#multiplot(p1, p2, p3, cols=1)
#
#p4 =ggplot(data = melt(final_matrix), aes(x = Var2, y = Var1)) +
#  geom_tile(aes(fill = value)) +scale_fill_gradient(low="yellow", high="red")+ theme(axis.text.x  = element_text(angle=90, vjust=0.5, size=10))
#multiplot(p4, cols=1)


#select predicted CT as column
#heatmap_collabel <- subset(label_file, label_file[,1] %in% colnames(heat_matrix))

#select all cells as column
heatmap_collabel <- label_file

rownames(heatmap_collabel) <- heatmap_collabel[,1]
heatmap_collabel[,1] <- NULL
colnames(heatmap_collabel) <- "CellType"
heatmap_collabel[,1] <- paste("CT",heatmap_collabel[,1],sep = "")

heatmap_rowlabel <- as.data.frame(gsub("-.*","",rownames(heat_matrix)))
rownames(heatmap_rowlabel) <- rownames(heat_matrix)
colnames(heatmap_rowlabel) <- "CellType"
new_rowname <- paste("Regulon",seq(1:nrow(heatmap_rowlabel)),sep = "")
ann_color_row <- colorRampPalette(brewer.pal(n = 7, name = "Dark2"))(nrow(unique(heatmap_collabel)))
names(ann_color_row) <- as.character(unique(heatmap_collabel[,1]))
ann_colors = list(
  CellType = ann_color_row
)
rownames(heat_matrix) <- new_rowname
rownames(heatmap_rowlabel) <- rownames(heat_matrix)
pheatmap(as.matrix(heat_matrix),color = colorRampPalette(brewer.pal(n = 7, name = "YlOrRd"))(100),
         cluster_cols = F, cluster_rows = F,annotation = heatmap_collabel,
         row_annotation = heatmap_rowlabel,row_annotation_legend =F)
write.table(heat_matrix,"heat_matrix.txt",quote = F,sep = "\t")
