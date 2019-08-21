####### preprocessing expression matrix based on SC3 ##########
options(check.names=F)
#removes genes/transcripts that are either expressed (expression value > 2) in less than X% of cells (rare genes/transcripts) 
#or expressed (expression value > 0) in at least (100 ??? X)% of cells (ubiquitous genes/transcripts). 
#By default, X is set at 6.

#library(GenomicAlignments)
#library(ensembldb)
#BiocManager::install("scran")

suppressPackageStartupMessages(library(stringr))
suppressPackageStartupMessages(library(hdf5r))
suppressPackageStartupMessages(library(stringr))
suppressPackageStartupMessages(library(SingleCellExperiment))
#suppressPackageStartupMessages(library(SC3))
suppressPackageStartupMessages(library(scater))
suppressPackageStartupMessages(library(devEMF))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(Seurat))
suppressPackageStartupMessages(library(DrImpute))
suppressPackageStartupMessages(library(scran))
suppressPackageStartupMessages(library(slingshot))
suppressPackageStartupMessages(library(destiny))
suppressPackageStartupMessages(library(gam))
suppressPackageStartupMessages(library(RColorBrewer))
suppressPackageStartupMessages(library(Polychrome))
suppressPackageStartupMessages(library(ggplot2))


args <- commandArgs(TRUE)
srcFile <- args[1] # raw user filename
jobid <- args[2] # user job id
delim <- args[3] #delimiter
is_gene_filter <- args[4] #1 for enable gene filtering
is_cell_filter <- args[5] #1 for enable cell filtering
label_file <- 1
label_file <- args[6] # user label file name or 1
delimiter <- args[7] 
param_k <- character()
param_k <- args[8] #k parameter for sc3
label_use_sc3 <- args[9] # 1 for have label use sc3, 2 for have label use label, 0 for no label use sc3


if(is.na(delim)){
  delim <- ','
} else if(delim == 'tab'){
  delim <- '\t'
} else if(delim == 'space'){
  delim <- ' '
} else if(delim == 'semicolon'){
  delim <- ';'
}else {
  delim <- ','
}

load_test_data <- function(){
  rm(list = ls(all = TRUE))
  # 
  # setwd("C:/Users/wan268/Documents/iris3_data/MM")
  # setwd("d:/Users/flyku/Documents/IRIS3-data/20190802103754")
  # setwd("C:/Users/wan268/Documents/iris3_data/20190802103754")
  #srcFile = "1k_hgmm_v3_filtered_feature_bc_matrix.h5"
  srcFile = "iris3_example_expression_matrix.csv"
  jobid <- "20190802103754"
  delim <- ","
  is_gene_filter <- 1
  is_cell_filter <- 1
  label_file<-'iris3_example_expression_label.csv'
  delimiter <- ','
  param_k<-0
  label_use_sc3 <- 2
}

##############################
# define a fucntion for reading in 10X hd5f data and cell gene matrix by input (TenX) or (CellGene)
read_data<-function(x=NULL,read.method=NULL,sep="\t",...){
  if(!is.null(x)){
    if(!is.null(read.method)){
      if(read.method !="TenX.h5"&&read.method!="CellGene"&&read.method!="TenX.folder"){
        stop("wrong 'read.method' argument, please choose 'TenX.h5','TenX.folder', or 'CellGene'!")}
      if(read.method == "TenX.h5"){
        tmp_x<-Read10X_h5(x)
        return(tmp_x)
      }else if(read.method =="TenX.folder"){
        tmp_x<-Read10X(getwd())
        return(tmp_x)
      } else if(read.method == "CellGene"){# read in cell * gene matrix, if there is error report, back to 18 line to run again.
        tmp_x<-read.delim(x,header = T,row.names = NULL,check.names = F,sep=sep,...)
        
        return(tmp_x)
      }
    }
  }else {stop("Missing 'x' argument, please input correct data")}
}

getwd()
upload_type <- as.character(read.table("upload_type.txt",stringsAsFactors = F)[1,1])
#expFile <- read_data(x = getwd(),read.method = "TenX.folder",sep = delim)
#expFile <- read_data(x = srcFile,read.method = "TenX.h5",sep = delim)
#upload_type <- "CellGene"
#expFile <- read_data(x = srcFile,read.method = "CellGene",sep = delim)
expFile <- read_data(x = srcFile,read.method = upload_type,sep = delim)
colnames(expFile) <-  gsub('([[:punct:]])|\\s+','_',colnames(expFile))

##check if [1,1] is empty
if(colnames(expFile)[1] == ""){
  colnames(expFile)[1] = "Gene_ID"
}

total_gene_num <- nrow(expFile)

## deal with some edge cases on gene symbols/id 
if (upload_type == "CellGene"){
  ## case: gene with id with ENSG########.X, remove part after dot, e.g:
  ## a <- c("ENSG00000064545.10","ENSG000031230064545","ENMUSG00003213004545.31234s")
  match_index <- grep("^ENSG.+\\.[0-9]",ignore.case = T,expFile[,1])
  if (length(match_index) > 0){
    match_rownames <- expFile[match_index,1]
    expFile[,1] <- as.character(expFile[,1])
    expFile[match_index,1] <- gsub('\\..+','',match_rownames)
  }
  
  ## case above but for mouse: ENSMUSGXXXXX.X
  match_index <- grep("^ENSMUSG.+\\.[0-9]",ignore.case = T,expFile[,1])
  if (length(match_index) > 0){
    match_rownames <- expFile[match_index,1]
    expFile[,1] <- as.character(expFile[,1])
    expFile[match_index,1] <- gsub('\\..+','',match_rownames)
  }
  
  ## case: genes with format like (AADACL3|chr1|12776118), remove part after |, e.g:
  ## a <- c("AADACL3|chr1|12776118","KLHDC8A|chr1|205305648","KIF21B|chr1|200938514")
  match_index <- grep("^[a-z].+\\|",ignore.case = T,expFile[,1])
  if (length(match_index) > 0){
    match_rownames <- expFile[match_index,1]
    expFile[,1] <- as.character(expFile[,1])
    expFile[match_index,1] <- gsub('\\|.+','',match_rownames)
  }
  
  ##remove duplicated rows with same gene 
  if(length(which(duplicated.default(expFile[,1]))) > 0 ){
    expFile <- expFile[-which(duplicated.default(expFile[,1])==T),]
  }	
  
  rownames(expFile) <- expFile[,1]
  expFile<- expFile[,-1]
}

total_cell_num <- ncol(expFile)


# detect rownames gene list with identifer by the largest number of matches: 1) gene symbol. 2)ensembl geneid. 3) ncbi entrez id. 4)

get_rowname_type <- function (l, db){
  res1 <- tryCatch(nrow(AnnotationDbi::select(db, keys = l, columns = c("ENTREZID", "SYMBOL","ENSEMBL","ENSEMBLTRANS"),keytype = "SYMBOL")),error = function(e) 0)
  res2 <- tryCatch(nrow(AnnotationDbi::select(db, keys = l, columns = c("ENTREZID", "SYMBOL","ENSEMBL","ENSEMBLTRANS"),keytype = "ENSEMBL")),error = function(e) 0)
  res3 <- tryCatch(nrow(AnnotationDbi::select(db, keys = l, columns = c("ENTREZID", "SYMBOL","ENSEMBL","ENSEMBLTRANS"),keytype = "ENTREZID")),error = function(e) 0)
  res4 <- tryCatch(nrow(AnnotationDbi::select(db, keys = l, columns = c("ENTREZID", "SYMBOL","ENSEMBL","ENSEMBLTRANS"),keytype = "ENSEMBLTRANS")),error = function(e) 0)
  result <- c("error","SYMBOL","ENSEMBL","ENTREZID","ENSEMBLTRANS")
  result_vec <- c(1,res1,res2,res3,res4)
  return(c(result[which.max(result_vec)],result_vec[which.max(result_vec)]))
  #write("No matched gene identifier found, please check your data.",file=paste(jobid,"_error.txt",sep=""),append=TRUE)
}

# detect species
# detect which types of identifer in rownames, 1)HGNC gene symbol 2)ensembl geneid 3) ncbi entrez id
# convert to symbol
species_file <- as.character(read.table("species.txt",header = F,stringsAsFactors = F)[,1])

# deprecated databases, about 10% of the gene id missing which cause a lot of genes filtered
suppressPackageStartupMessages(library(org.Dm.eg.db))
suppressPackageStartupMessages(library(org.Hs.eg.db))
suppressPackageStartupMessages(library(org.Mm.eg.db))
suppressPackageStartupMessages(library(org.Ce.eg.db))
suppressPackageStartupMessages(library(org.Sc.sgd.db))
suppressPackageStartupMessages(library(org.Dr.eg.db))
db <- c("Worm"=org.Ce.eg.db, "Fruit_fly"=org.Dm.eg.db, "Zebrafish"=org.Dr.eg.db,
        "Yeast"=org.Sc.sgd.db,"Mouse"=org.Mm.eg.db,"Human"=org.Hs.eg.db)

select_db <- db[which(names(db)%in%species_file)]
gene_identifier <- sapply(select_db, get_rowname_type, l=rownames(expFile))
main_species <- names(which.max(gene_identifier[2,]))
main_db <- db[which(names(db)%in%main_species)][[1]]
main_identifier <- as.character(gene_identifier[1,which.max(gene_identifier[2,])])

if(length(species_file) == 2) {
  second_species <- names(which.min(gene_identifier[2,]))
  write(paste("second_species,",second_species,sep=""),file=paste(jobid,"_info.txt",sep=""),append=TRUE)
}
all_match <- AnnotationDbi::select(main_db, keys = rownames(expFile), columns = c("SYMBOL","ENSEMBL"),keytype = main_identifier)

expFile <- merge(expFile,all_match,by.x=0,by.y=main_identifier)
expFile <- na.omit(expFile)

## merge expression values with same gene names
if (main_identifier == "ENSEMBL") {
  expFile <- expFile[,-1]
  expFile <- aggregate(. ~ SYMBOL, expFile, sum)
} else if (main_identifier == "ENSEMBLTRANS") {
  expFile <- expFile[,c(-1,-(ncol(expFile)))]
  expFile <- aggregate(. ~ SYMBOL, expFile, sum)
} else {
  expFile <- expFile[,-(ncol(expFile))]
  expFile <- aggregate(. ~ Row.names, expFile, sum)
}
expFile <- expFile[!duplicated(expFile[,1]),]
rownames(expFile) <- expFile[,1]
expFile <- expFile[,-1]

## remove rows with empty gene name
if(length(which(rownames(expFile)=="")) > 0){
  expFile <- expFile[-which(rownames(expFile)==""),]
}

## keep the gene with number of non-0 expression value cells >= 5%
filter_gene_func <- function(this){
  if(length(which(this>0)) >= thres_cells){
    return (1)
  } else {
    return (0)
  }
}
# this <- expFile[,1]
## keep the cell with number of non-0 expression value gene >= 1%
filter_cell_func <- function(this){
  if(length(which(this>0)) >= thres_genes){
    return (1)
  } else {
    return (0)
  }
}

my.object<-CreateSeuratObject(expFile)

if (upload_type == "TenX.folder" | upload_type == "TenX.h5"){
  my.object[["percent.mt"]] <- PercentageFeatureSet(my.object, pattern = "^MT-")
  my.object <- (subset(my.object, subset = nFeature_RNA > 200 & nFeature_RNA < 3000 & percent.mt < 5))
}

## get raw data################################  
my.count.data<-GetAssayData(object = my.object[['RNA']],slot="counts")
sce<-SingleCellExperiment(list(counts=my.count.data))

## if all values are integers, perform normalization, otherwise skip to imputation
if(all(as.numeric(unlist(my.count.data[nrow(my.count.data),]))%%1==0)){
## normalization##############################
  sce <- tryCatch(computeSumFactors(sce),error = function(e) computeSumFactors(sce, sizes=seq(21, 201, 5)))
  sce<-scater::normalize(sce,return_log=F)
  my.normalized.data <- normcounts(sce)
} else {
  my.normalized.data <- my.count.data
}

## imputation#################################

my.imputated.data <- DrImpute(as.matrix(my.normalized.data),ks=12,dists = "spearman")

colnames(my.imputated.data)<-colnames(my.count.data)
rownames(my.imputated.data)<-rownames(my.count.data)
my.imputated.data<- as.sparse(my.imputated.data)
my.imputatedLog.data<-log1p(my.imputated.data)

thres_genes <- nrow(my.imputatedLog.data) * 0.01
thres_cells <- ncol(my.imputatedLog.data) * 0.05

## apply gene filtering
if(is_gene_filter == "1"){
  gene_index <- as.vector(apply(my.imputatedLog.data, 1, filter_gene_func))
  my.imputatedLog.data <- my.imputatedLog.data[which(gene_index == 1),]
  expFile <- expFile[which(gene_index == 1),]
} 
## apply cell filtering
if(is_cell_filter == "1"){
  cell_index <- as.vector(apply(my.imputatedLog.data, 2, filter_cell_func))
  my.imputatedLog.data <- my.imputatedLog.data[,which(cell_index == 1)]
  expFile <- expFile[,colnames(my.imputatedLog.data)]
} 

dim(my.imputatedLog.data)
dim(expFile)

## 
my.object<-0
my.object<-CreateSeuratObject(expFile)
my.object<-SetAssayData(object = my.object,slot = "data",new.data = my.imputatedLog.data,assay="RNA")
cell_names <- colnames(my.object)


## calculate filtering rate
#filter_gene_num <- nrow(expFile)-nrow(my.object)
filter_gene_num <- total_gene_num-nrow(my.object)
filter_gene_rate <- formatC(filter_gene_num/total_gene_num,digits = 2)
filter_cell_num <- total_cell_num-ncol(my.object)
filter_cell_rate <- formatC(filter_cell_num/total_cell_num,digits = 2)
if(filter_cell_num == 0){
  filter_cell_rate <- '0'
}


exp_data <- GetAssayData(object = my.object,slot = "data")
#write.table(cbind(filter_num,filter_rate,nrow(expFile)), paste(jobid,"_filtered_rate.txt",sep = ""),sep = "\t", row.names = F,col.names = F,quote = F)
write(paste("filter_gene_num,",as.character(filter_gene_num),sep=""),file=paste(jobid,"_info.txt",sep=""),append=TRUE)
write(paste("total_gene_num,",as.character(total_gene_num),sep=""),file=paste(jobid,"_info.txt",sep=""),append=TRUE)
write(paste("filter_gene_rate,",as.character(filter_gene_rate),sep=""),file=paste(jobid,"_info.txt",sep=""),append=TRUE)
write(paste("filter_cell_num,",as.character(filter_cell_num),sep=""),file=paste(jobid,"_info.txt",sep=""),append=TRUE)
write(paste("total_cell_num,",as.character(total_cell_num),sep=""),file=paste(jobid,"_info.txt",sep=""),append=TRUE)
write(paste("filter_cell_rate,",as.character(filter_cell_rate),sep=""),file=paste(jobid,"_info.txt",sep=""),append=TRUE)
write(paste("main_species,",main_species,sep=""),file=paste(jobid,"_info.txt",sep=""),append=TRUE)
write.table(as.data.frame(expFile),paste(jobid,"_raw_expression.txt",sep = ""), row.names = T,col.names = T,sep="\t",quote=FALSE)
#write.table(as.data.frame(exp_data),paste(jobid,"_filtered_expression.txt",sep = ""), row.names = F,col.names = c(colnames(exp_data)),sep="\t",quote=FALSE)
write.table(data.frame("Gene"=rownames(exp_data),exp_data,check.names = F),paste(jobid,"_filtered_expression.txt",sep = ""), row.names = F,sep="\t",quote=FALSE)


rm(my.imputated.data)
rm(my.normalized.data)
rm(expFile)
rm(my.imputatedLog.data)


if (label_file == 0 | label_file==1){
  cell_info <- colnames(exp_data)
} else {
  if(delimiter == 'tab'){
    delimiter <- '\t'
  }
  if(delimiter == 'space'){
    delimiter <- ' '
  }
  cell_info <- read.table(label_file,check.names = FALSE, header=TRUE,sep = delimiter)
  cell_info[,2] <- as.factor(cell_info[,2])
}
## sc3 disabled
if(label_use_sc3 == 3){
  # create a SingleCellExperiment object
  sce <- SingleCellExperiment(
    assays = list(
      counts = as.matrix(exp_data),
      logcounts = log2(as.matrix(exp_data) + 1)
    ), 
    colData = cell_info
  )
  
  # define feature names in feature_symbol column
  rowData(sce)$feature_symbol <- rownames(sce)
  # remove features with duplicated names
  sce <- sce[!duplicated(rowData(sce)$feature_symbol), ]
  sce <- sc3_prepare(sce)
  
  if (as.numeric(param_k)>0){
    sce <- sc3_calc_dists(sce)
    sce <- sc3_calc_transfs(sce)
    sce <- sc3_kmeans(sce, ks = as.numeric(param_k))
  } else {
    sce <- sc3_estimate_k(sce)
    sce <- sc3_calc_dists(sce)
    sce <- sc3_calc_transfs(sce)
    sce <- sc3_kmeans(sce, ks = metadata(sce)$sc3$k_estimation)
  }
  
  sce <- sc3_calc_consens(sce)
  # get row data for section 5.2 Silhouette Plot
  # silh stores the bar width
  # modify k to the number of cluster
  silh <- metadata(sce)$sc3$consensus[[1]]$silhouette
  #silh[,2] = seq(1:nrow(silh))
  save_image <- function(type,filetype){
    if(filetype == "jpeg" || filetype == "png"){
      type(file=paste("saving_plot1.",as.character(filetype),sep=""),width=1200, height=1200)
    } else if (filetype == "pdf"){
      type(file=paste("saving_plot1.",as.character(filetype),sep=""))
    } else if (filetype == "emf"){
      library(devEMF)
      emf(file="saving_plot1.emf", emfPlus = FALSE)
    }
    if (as.numeric(param_k)>0){
      sc3_plot_consensus(sce,param_k,show_pdata=c(colnames(colData(sce))[2]))
    } else {
      sc3_plot_consensus(sce,metadata(sce)$sc3$k_estimation,show_pdata=c(colnames(colData(sce))[2]))
    }
    dev.off()
  }
  
  if (label_file == 1){
    silh_out <- cbind(silh[,1],as.character(cell_info),silh[,3])
  } else {
    silh_out <- cbind(silh[,1],as.character(cell_info[,1]),silh[,3])
  }
  
  save_image(pdf,"pdf")
  save_image(emf,"emf")
  save_image(png,"png")
  save_image(jpeg,"jpeg")
  silh_out <- silh_out[order(silh[,1]),]
  write.table(silh_out,paste(jobid,"_silh.txt",sep=""),sep = ",",quote = F,col.names = F,row.names = F)
  #apply(silh, 1, write,file=paste(jobid,"_silh.txt",sep=""),append=TRUE,sep = ",")
  
  cell_info <- as.data.frame(colData(sce))
  cell_info <- cbind(rownames(cell_info),cell_info[,ncol(cell_info)])
  colnames(cell_info) <- c("cell_name","label")
  write.table(cell_info,paste(jobid,"_sc3_label.txt",sep = ""),quote = F,row.names = F,sep = "\t")
  
} 


my.object<-FindVariableFeatures(my.object,selection.method = "vst",nfeatures = 5000)

# before PCA, scale data to eliminate extreme value affect.
all.gene<-rownames(my.object)
my.object<-ScaleData(my.object,features = all.gene)
# after scaling, perform PCA

if(ncol(my.object) < 50) {
  my.object<-RunPCA(my.object,rev.pca = F,features = VariableFeatures(object = my.object), npcs = ncol(my.object)-1)
} else {
  my.object<-RunPCA(my.object,rev.pca = F,features = VariableFeatures(object = my.object))
}
head(Embeddings(my.object, reduction = "pca")[, 1:5])

num_pca <- which(cumsum(Stdev(my.object,reduction = "pca")/sum(Stdev(my.object,reduction = "pca"))) > 0.8)[1]

plot(cumsum(Stdev(my.object,reduction = "pca")/sum(Stdev(my.object,reduction = "pca"))),type='o')

my.object<-FindNeighbors(my.object,dims = 1:30)
my.object<-FindClusters(my.object)
cell_info <-  my.object$seurat_clusters
cell_label <- cbind(cell_names,cell_info)
colnames(cell_label) <- c("cell_name","label")
write.table(cell_label,paste(jobid,"_sc3_label.txt",sep = ""),quote = F,row.names = F,sep = "\t")
#write.table(cell_label,paste(jobid,"_cell_label.txt",sep = ""),quote = F,row.names = F,sep = "\t")

if (label_use_sc3 =='2'){
  cell_info <- read.table(label_file,check.names = FALSE, header=TRUE,sep = delimiter)
  ## check if user's label has valid number of rows, if not just use predicted value
  if (nrow(cell_info) == nrow(cell_label)){
    original_cell_info <- as.factor(cell_info[,2])
    cell_info[,2] <- as.numeric(as.factor(cell_info[,2]))
    rownames(cell_info) <- cell_info[,1]
    cell_info <- cell_info[,-1]
  } else {
    cell_info <-  my.object$seurat_clusters
  }
} 
silh_out <- cbind(cell_info,cell_names,1)
silh_out <- silh_out[order(silh_out[,1]),]
write.table(silh_out,paste(jobid,"_silh.txt",sep=""),sep = ",",quote = F,col.names = F,row.names = F)
my.object<-AddMetaData(my.object,cell_info,col.name = "Customized.idents")
Idents(my.object)<-as.factor(my.object$Customized.idents)

###########################################
# CORE part: Run TSNE and UMAP######################
###########################################
my.object<-RunTSNE(my.object,dims = 1:30,perplexity=10,dim.embed = 3)
# run umap to get high dimension scatter plot at 2 dimensional coordinate system.
##my.object<-RunUMAP(object = my.object,dims = 1:30)
#clustering by using Seurat KNN. 
# clustering by using KNN, this is seurat cluster algorithm, this part only for cell categorization
# here has one problems: whether should we define the clustering number?

# find clustering, there will be changing the default cell type, if want to use customized cell type. 
# use Idents() function.


Get.MarkerGene<-function(my.object, customized=T){
  if(customized){
    Idents(my.object)<-my.object$Customized.idents
    my.marker<-FindAllMarkers(my.object,only.pos = T)
  } else {
    Idents(my.object)<-my.object$seurat_clusters
    my.marker<-FindAllMarkers(my.object,only.pos = T)
  }
  my.cluster<-unique(as.character(as.numeric(Idents(my.object))))
  my.top.20<-c()
  for( i in 1:length(my.cluster)){
    my.cluster.data.frame<-filter(my.marker,cluster==my.cluster[i])
    my.top.20.tmp<-list(my.cluster.data.frame$gene[1:100])
    my.top.20<-append(my.top.20,my.top.20.tmp)
  }
  names(my.top.20)<-paste0("CT",my.cluster)
  my.top.20<-as.data.frame(my.top.20)
  return(my.top.20)
}

my.cluster.uniq.marker<-Get.MarkerGene(my.object,customized = T)

sort_column <- function(df) {
  tmp <- colnames(df)
  split <- strsplit(tmp, "CT") 
  split <- as.numeric(sapply(split, function(x) x <- sub("", "", x[2])))
  return(order(split))
}
my.cluster.uniq.marker <- my.cluster.uniq.marker[,sort_column(my.cluster.uniq.marker)]
write.table(my.cluster.uniq.marker,file = "cell_type_unique_marker.txt",quote = F,row.names = F,sep = "\t")
saveRDS(my.object,file="seurat_obj.rds")

###### Remove Monocle trajectory ###########
#cds<-importCDS(my.object,import_all = T)
#cds<- estimateSizeFactors(cds)
#cds<-reduceDimension(cds,max_components = 2, method='DDRTree')
# test time and RAM
# library(profvis)
# profvis({
#   monocle_obj<-reduceDimension(monocle_obj,max_components = 2, method='DDRTree')
# })
#cds<-orderCells(cds)
#saveRDS(cds,file="monocle_obj.rds")
###### Remove Monocle trajectory ###########


my.trajectory<-SingleCellExperiment(assays=List(counts=GetAssayData(object = my.object[['RNA']],slot="counts")))
SummarizedExperiment::assays(my.trajectory)$norm<-exp_data

dm<-DiffusionMap(t(as.matrix(SummarizedExperiment::assays(my.trajectory)$norm)))
rd2 <- cbind(DC1 = dm$DC1, DC2 = dm$DC2)
reducedDims(my.trajectory) <- SimpleList(DiffMap = rd2)
saveRDS(my.trajectory,file="trajectory_obj.rds")


Plot.cluster2D<-function(reduction.method="tsne",module=1,customized=F,...){
  # my.plot.source<-GetReduceDim(reduction.method = reduction.method,module = module,customized = customized)
  # my.module.mean<-colMeans(my.gene.module[[module]]@assays$RNA@data)
  # my.plot.source<-cbind.data.frame(my.plot.source,my.module.mean)
  if(!customized){
    my.plot.all.source<-cbind.data.frame(Embeddings(my.object,reduction = reduction.method),
                                         Cell_type=my.object$seurat_clusters)
  }else{
    my.plot.all.source<-cbind.data.frame(Embeddings(my.object,reduction = reduction.method),
                                         Cell_type=as.factor(my.object$Customized.idents))
  }
  p.cluster <- ggplot(my.plot.all.source,
                      aes(x=my.plot.all.source[,1],y=my.plot.all.source[,2]))+xlab(colnames(my.plot.all.source)[1])+ylab(colnames(my.plot.all.source)[2])
  p.cluster <- p.cluster+geom_point(aes(col=my.plot.all.source[,"Cell_type"]))+scale_color_manual(values  = as.character(palette36.colors(36))[-2])
  #p.cluster<-theme_linedraw()
  p.cluster <- p.cluster + labs(col="cell type")
  p.cluster <- p.cluster + theme_classic()+scale_fill_continuous(name="cell type")
  p.cluster <- p.cluster + coord_fixed(ratio=1)
  p.cluster
}

reset_par <- function(){
  op <- structure(list(xlog = FALSE, ylog = FALSE, adj = 0.5, ann = TRUE,
                       ask = FALSE, bg = "transparent", bty = "o", cex = 1, cex.axis = 1,
                       cex.lab = 1, cex.main = 1.2, cex.sub = 1, col = "black",
                       col.axis = "black", col.lab = "black", col.main = "black",
                       col.sub = "black", crt = 0, err = 0L, family = "", fg = "black",
                       fig = c(0, 1, 0, 1), fin = c(6.99999895833333, 6.99999895833333
                       ), font = 1L, font.axis = 1L, font.lab = 1L, font.main = 2L,
                       font.sub = 1L, lab = c(5L, 5L, 7L), las = 0L, lend = "round",
                       lheight = 1, ljoin = "round", lmitre = 10, lty = "solid",
                       lwd = 1, mai = c(1.02, 0.82, 0.82, 0.42), mar = c(5.1, 4.1,
                                                                         4.1, 2.1), mex = 1, mfcol = c(1L, 1L), mfg = c(1L, 1L, 1L,
                                                                                                                        1L), mfrow = c(1L, 1L), mgp = c(3, 1, 0), mkh = 0.001, new = FALSE,
                       oma = c(0, 0, 0, 0), omd = c(0, 1, 0, 1), omi = c(0, 0, 0,
                                                                         0), pch = 1L, pin = c(5.75999895833333, 5.15999895833333),
                       plt = c(0.117142874574832, 0.939999991071427, 0.145714307397962,
                               0.882857125425167), ps = 12L, pty = "m", smo = 1, srt = 0,
                       tck = NA_real_, tcl = -0.5, usr = c(0.568, 1.432, 0.568,
                                                           1.432), xaxp = c(0.6, 1.4, 4), xaxs = "r", xaxt = "s", xpd = FALSE,
                       yaxp = c(0.6, 1.4, 4), yaxs = "r", yaxt = "s", ylbias = 0.2), .Names = c("xlog",
                                                                                                "ylog", "adj", "ann", "ask", "bg", "bty", "cex", "cex.axis",
                                                                                                "cex.lab", "cex.main", "cex.sub", "col", "col.axis", "col.lab",
                                                                                                "col.main", "col.sub", "crt", "err", "family", "fg", "fig", "fin",
                                                                                                "font", "font.axis", "font.lab", "font.main", "font.sub", "lab",
                                                                                                "las", "lend", "lheight", "ljoin", "lmitre", "lty", "lwd", "mai",
                                                                                                "mar", "mex", "mfcol", "mfg", "mfrow", "mgp", "mkh", "new", "oma",
                                                                                                "omd", "omi", "pch", "pin", "plt", "ps", "pty", "smo", "srt",
                                                                                                "tck", "tcl", "usr", "xaxp", "xaxs", "xaxt", "xpd", "yaxp", "yaxs",
                                                                                                "yaxt", "ylbias"))
  par(op)
}

Get.cluster.Trajectory<-function(customized=T,start.cluster=NULL,end.cluster=NULL,...){
  #labeling cell
  if(customized==TRUE){
    tmp.cell.type<-my.object$Customized.idents
  }
  if(customized==FALSE){
    tmp.cell.type<-as.character(my.object$seurat_clusters)
  }
  tmp.cell.name.index<-match(colnames(my.trajectory),colnames(my.object))
  tmp.cell.type<-tmp.cell.type[tmp.cell.name.index]
  colData(my.trajectory)$cell.label<-tmp.cell.type
  # run trajectory, first run the lineage inference
  my.trajectory <- slingshot(my.trajectory, clusterLabels = 'cell.label', reducedDim = 'DiffMap',
                             start.clus=start.cluster,end.clus=end.cluster)
  #summary(my.trajectory$slingPseudotime_1)
  return(my.trajectory)
}


Plot.Cluster.Trajectory<-function(customized=T,add.line=TRUE,start.cluster=NULL,end.cluster=NULL,show.constraints=F,...){
  tmp.trajectory.cluster<-Get.cluster.Trajectory(customized = customized,start.cluster=start.cluster,end.cluster=end.cluster)
  my.classification.color<-as.character(palette36.colors(36))[-2]
  par(mar=c(3.1, 3.1, 2.1, 5.1), xpd=TRUE)
  plot(reducedDims(tmp.trajectory.cluster)$DiffMap,
       col=alpha(my.classification.color[as.factor(tmp.trajectory.cluster$cell.label)],0.7),
       pch=20,frame.plot = FALSE,
       asp=1)
  #grid()
  tmp.color.cat<-cbind.data.frame(CellName=as.character(tmp.trajectory.cluster$cell.label),
                                  Color=my.classification.color[as.factor(tmp.trajectory.cluster$cell.label)])
  tmp.color.cat<-tmp.color.cat[!duplicated(tmp.color.cat$CellName),]
  tmp.color.cat<-tmp.color.cat[order(as.numeric(tmp.color.cat$CellName)),]
  # add legend
  if(length(tmp.color.cat$CellName)>10){
    legend("topright",legend = tmp.color.cat$CellName,
           inset=c(0.1,0), ncol=2,
           col = tmp.color.cat$Color,pch = 20,
           cex=0.8,title="cluster",bty='n')
  } else {legend("topright",legend = tmp.color.cat$CellName,
                 inset=c(0.1,0), ncol=1,
                 col = tmp.color.cat$Color,pch = 20,
                 cex=0.8,title="cluster",bty='n')}
  
  
  if(add.line==T){
    lines(SlingshotDataSet(tmp.trajectory.cluster), 
          lwd=1,pch=3, col=alpha('black',0.7),
          type="l",show.constraints=show.constraints)
  }
  reset_par()
}

quiet <- function(x) {
  sink(tempfile()) 
  on.exit(sink()) 
  invisible(force(x)) 
} 


png(paste("regulon_id/overview_ct.png",sep = ""),width=1600, height=1200,res = 300)
Plot.cluster2D(reduction.method = "tsne",customized = T)
quiet(dev.off())

png(paste("regulon_id/overview_ct.trajectory.png",sep = ""),width=1600, height=1200,res = 300)
Plot.Cluster.Trajectory(customized= T,start.cluster=NULL,add.line = T,end.cluster=NULL,show.constraints=T)
quiet(dev.off())
