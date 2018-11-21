#######  Read all motif result, convert to input for BBC ##########
# remove all empty files before this



library(GenomicAlignments)
library(ensembldb)
library(EnsDb.Hsapiens.v86)
library(magic)
library(Matrix)
library(ggplot2)
library(reshape2)
args <- commandArgs(TRUE)

srcDir <- args[1]
setwd(srcDir)
getwd()
workdir <- getwd()
all_regulon <- list.files(path = workdir,pattern = "._bic.regulon.txt$")
all_label <- list.files(path = workdir,pattern = ".+cell_label.txt$")[1]
label_file <- read.table(all_label,header = T)
exp_file <- read.table("2018111413246_filtered_expression.txt",stringsAsFactors = F,header = T,check.names = F)


i=j=k=1
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  require(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}
generate_name <- function(df){
  genes <- regulon_file
  for (i in 1:ncol(genes)) {
    name <- colnames(genes)[i]
    result <- genes(EnsDb.Hsapiens.v86, filter=list(GeneIdFilter(as.character(genes[,i]))), 
                    return.type="data.frame", columns=c("gene_name"))
  }
}


#result <- genes(EnsDb.Hsapiens.v86, filter=list(GeneIdFilter(rownames(exp_file))), return.type="data.frame", columns=c("gene_name"))
result <- genes(EnsDb.Hsapiens.v86, filter=list(GenenameFilter(rownames(exp_file)),GeneIdFilter("ENSG", "startsWith")), 
                return.type="data.frame", columns=c("gene_id"))

heat_matrix <- data.frame(matrix(ncol = nrow(label_file), nrow = 0))
colnames(heat_matrix) <- as.character(label_file[,1])
final_list <- list()
final_matrix  <- matrix()

i=2
index_gene_name<-index_cell_type <- vector()
for (i in 1:length(all_regulon)) {
  heat_matrix <- data.frame(matrix(ncol = nrow(label_file), nrow = 0))
  colnames(heat_matrix) <- as.character(label_file[,1])
  regulon_file <- read.table(all_regulon[i],header = F,fill = T,row.names = 1)
  num_cell_type <- as.numeric(sub(".*_CT_ *(.*?) *_bic.*", "\\1", all_regulon[i]))
  regulon_cell_type <- label_file[which(label_file[,2] == num_cell_type),1]
  for (j in 1:nrow(regulon_file)) {
    regulon_gene_name <- genes(EnsDb.Hsapiens.v86, filter=list(GeneIdFilter(as.character(regulon_file[,j]))), 
                          return.type="data.frame", columns=c("gene_name"))[,1]
    for (k in 1:length(regulon_gene_name)) {
      index_gene_name[k] <- which(rownames(exp_file)==regulon_gene_name[k])
    }
    for (k in 1:length(regulon_cell_type)) {
      index_cell_type[k] <- which(colnames(exp_file)==as.character(regulon_cell_type[k]))
    }
    regulon_in_exp <- exp_file[index_gene_name,index_cell_type]
    regulon_all_exp <- exp_file[index_gene_name,]
    
    tmp_heat_matrix <- t(as.data.frame(colMeans(regulon_in_exp)))
    rownames(tmp_heat_matrix) <- paste("CT",num_cell_type,"-Regulon",j,sep = "")
    heat_matrix <- rbind(heat_matrix,tmp_heat_matrix)
    
  }

  final_list[[i]] <- as.matrix(heat_matrix)
  
}

final_matrix <- do.call(adiag, final_list)
final_matrix[final_matrix==0] <- NA
write.table(final_matrix,"final_matrix.txt",quote = F)

p1 =ggplot(data = melt(final_list[[1]]), aes(x = Var2, y = Var1)) +
  geom_tile(aes(fill = value)) +scale_fill_gradient(low="yellow", high="red")

p2 =ggplot(data = melt(final_list[[2]]), aes(x = Var2, y = Var1)) +
  geom_tile(aes(fill = value)) +scale_fill_gradient(low="yellow", high="red")

p3 =ggplot(data = melt(final_list[[3]]), aes(x = Var2, y = Var1)) +
  geom_tile(aes(fill = value)) +scale_fill_gradient(low="yellow", high="red")


multiplot(p1, p2, p3, cols=1)
