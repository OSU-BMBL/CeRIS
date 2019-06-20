# set working directory, you may change the directory first.
setwd("/home/cyz/Bigstore/BigData/runningdata/outs")
# loading required packege
if(!require(Seurat)) {
  install.packages("Seurat")
} 
if(!require(hdf5r)) {
  install.packages("hdf5r")
} 

if(!require(Matrix)) {
  install.packages("Matrix")
}
if(!require(plotly)){
  install.packages("plotly")
}
if (!require("RColorBrewer")) {
  install.packages("RColorBrewer")
}
if (!require("Polychrome")) {
  install.packages("Polychrome")
  library(Polychrome)
}
if (!require("AUCell")) {
  BiocManager::install("AUCell")
  library(AUCell)
}
if (!require("dplyr")) {
  install.packages("dplyr")
  library(dplyr)
}

#pre-optional
options(stringsAsFactors = F)
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
        tmp_x<-Read10X(x)
        return(tmp_x)
      } else if(read.method == "CellGene"){# read in cell * gene matrix, if there is error report, back to 18 line to run again.
        tmp_x<-read.delim(x,header = T,row.names = 1,check.names = F,sep=sep,...)
        tmp_x<-as.sparse(tmp_x)
        return(tmp_x)
      }
    }
  }else {stop("Missing 'x' argument, please input correct data")}
}
#####################  
# rad.data function:#
#####################
# Two input arguments.
# 1. input files are gene(row)*cell(column) matrix, h5 file, and folder which 
#     contains 3 gz files(barcodes.tsv.gz, features.tsv.gz,matrix.mtx.gz)
# 2. input methods selection (3 modes)
#|-----------------|---------------|
#|x                |read.method    |
#|-----------------|---------------|
#|Gene Cell matrix |CellGene       |
#|10X h5df file    |TenX.h5        |
#|10X folder       |TenX.folder    |
#|-----------------|---------------|

#Read in data ###################################################
my.raw.data<-read_data(x = "Yan_RPKM",read.method = "CellGene")
######################################################
# create Seurat object
my.object<-CreateSeuratObject(my.raw.data)
# check how many cell and genes
dim(my.object)
#####################################################
# get data in terms of "counts"(raw data), "data"(normalized data), "scale.data"(scaling the data)
# neglect quality check, may add on in the future
##################################
# export data from seurat object.#
##################################
my.expression.data<-GetAssayData(object = my.object,slot = "counts")
write.table(my.expression.data,
            file = "RNA_RAW_EXPRESSION.txt",
            quote = F,
            sep = "\t")
#################################

# Key part for customizing cell type: 
##############################################
# Add meta info(cell type) to seurat object###
##############################################
my.meta.info<-read.table("./websiteoutput/test_zscore/2019052895653_cell_label.txt",sep = "\t",row.names = 1,header = T,stringsAsFactors = F)
my.object<-AddMetaData(my.object,my.meta.info,col.name = "Customized.idents")
# look at current cell type info
Idents(my.object)
# activate customized cell type info
Idents(my.object)<-as.factor(my.object$Customized.idents)
############################################## normalize data 
my.object<-NormalizeData(my.object,normalization.method = "LogNormalize",scale.factor = 10000)
# find high variable gene
my.object<-FindVariableFeatures(my.object,selection.method = "vst",nfeatures = 5000)
# before PCA, scale data to eliminate extreme value affect.
all.gene<-rownames(my.object)
my.object<-ScaleData(my.object,features = all.gene)
# after scaling, perform PCA
my.object<-RunPCA(my.object,rev.pca = F,features = VariableFeatures(object = my.object))
###########################################
# CORE part: Run TSNE and UMAP######################
###########################################
my.object<-RunTSNE(my.object,dims = 1:30,perplexity=10,dim.embed = 3)
# run umap to get high dimension scatter plot at 2 dimensional coordinate system.
my.object<-RunUMAP(object = my.object,dims = 1:30)
#clustering by using Seurat KNN. 
# clustering by using KNN, this is seurat cluster algorithm, this part only for cell categorization
# here has one problems: whether should we define the clustering number?
my.object<-FindNeighbors(my.object,k.param = 6,dims = 1:30)
# find clustering, there will be changing the default cell type, if want to use customized cell type. 
# use Idents() function.
my.object<-FindClusters(my.object,resolution = 0.5)

# input website CTS-R under a specific cell type
# in this example I let my.cts.regulon read in specific cell type 1 
# create gene Module, please provide a creat module format!
# M1  G1  G2.....#
# M2  G3  G4.....#
# M3  G5  G6.....#
#----------------#

setwd("/home/cyz/Bigstore/BigData/runningdata/outs/websiteoutput/test_zscore")
Get.CellType<-function(cell.type=NULL,...){
  if(!is.null(cell.type)){
    my.cell.regulon.filelist<-list.files(pattern = "bic.regulon_gene_name.txt")
    my.cell.regulon.indicator<-grep(paste0("_",as.character(cell.type),"_bic"),my.cell.regulon.filelist)
    my.cts.regulon.raw<-readLines(my.cell.regulon.filelist[my.cell.regulon.indicator])
    my.regulon.list<-strsplit(my.cts.regulon.raw,"\t")
    return(my.regulon.list)
  }else{stop("please input a cell type")}
  
}
Get.CellType(cell.type = 1,regulon=1)

Generate.Regulon<-function(cell.type=NULL,regulon=1,...){
  x<-Get.CellType(cell.type = cell.type)
  tmp.regulon<-subset(my.object,cells = colnames(my.object),features = x[[regulon]][-1])
  return(tmp.regulon)
}
Generate.Regulon(cell.type = 1,regulon = 1)
# read in motif score and 
# next step will take 1min to generate the mixed matrix

# cells_rankings<-AUCell_buildRankings(my.object@assays$RNA@data)



Get.RegulonScore<-function(reduction.method="tsne",cell.type=1,regulon=1,customized=F,...){
  my.regulon.number<-length(Get.CellType(cell.type = cell.type))
  if (regulon > my.regulon.number){
    stop(paste0("Regulon number exceeds the boundary. Under this cell type, there are total ", my.regulon.number," regulons"))
  } else {
    my.cts.regulon.S4<-Generate.Regulon(cell.type = cell.type,regulon=regulon)
    if(customized){
      my.cell.type<-my.cts.regulon.S4$Customized.idents
      message(c("using customized cell label: ","|", paste0(unique(as.character(my.cts.regulon.S4$Customized.idents)),"|")))
    }else{
      my.cell.type<-my.cts.regulon.S4$seurat_clusters
      message(c("using default cell label(seurat prediction): ","|", paste0(unique(as.character(my.cts.regulon.S4$seurat_clusters)),"|")))
    } 
    tmp_data<-as.data.frame(my.cts.regulon.S4@assays$RNA@data)
    # geneSets<-list(GeneSet1=rownames(tmp_data))
    # cells_AUC<-AUCell_calcAUC(geneSets,cells_rankings,aucMaxRank = nrow(cells_rankings)*0.05)
    # cells_assignment<-AUCell_exploreThresholds(cells_AUC,plotHist = T,nCores = 1,assign = T)
    # my.auc.data<-as.data.frame(cells_AUC@assays@.xData$data$AUC)
    # my.auc.data<-t(my.auc.data[,colnames(tmp_data)])
    regulon.score<-colMeans(tmp_data)/apply(tmp_data,2,sd)
    tmp.embedding<-Embeddings(my.object,reduction = reduction.method)[colnames(my.cts.regulon.S4),][,c(1,2)]
    my.choose.regulon<-cbind.data.frame(tmp.embedding,Cell_type=my.cell.type,
                                        regulon.score=regulon.score)
    
    return(my.choose.regulon)
  }
}
Get.RegulonScore(reduction.method = "tsne",cell.type = 2,regulon = 3,customized = T)
##############################

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
  p.cluster<-ggplot(my.plot.all.source,
                    aes(x=my.plot.all.source[,1],y=my.plot.all.source[,2]))+xlab(colnames(my.plot.all.source)[1])+ylab(colnames(my.plot.all.source)[2])
  p.cluster<-p.cluster+geom_point(aes(col=my.plot.all.source[,"Cell_type"]))+scale_color_manual(values  = as.character(palette36.colors(36))[-2])
  #p.cluster<-theme_linedraw()
  p.cluster<-p.cluster + labs(col="cell type")
  p.cluster+theme_light()+scale_fill_continuous(name="cell type")
  
}

# test plot cluster function. 
Plot.cluster2D(reduction.method = "tsne",customized = T)

# plot CTS-R



# test Get.RegulonScore, output is matrix


Plot.regulon2D<-function(reduction.method="tsne",regulon=1,cell.type=1,customized=F,...){
  message("plotting regulon ",regulon," of cell type ",cell.type,"...")
  my.plot.regulon<-Get.RegulonScore(reduction.method = reduction.method,
                                    cell.type = cell.type,
                                    regulon = regulon,
                                    customized = customized)
  # if(!customized){
  #   my.plot.all.source<-cbind.data.frame(Embeddings(my.object,reduction = reduction.method),
  #                                        Cell_type=my.object$seurat_clusters)
  #   my.plot.all.source<-my.plot.all.source[,grep("*\\_[1,2,a-z]",colnames(my.plot.all.source))]
  # }else{
  #   my.plot.all.source<-cbind.data.frame(Embeddings(my.object,reduction = reduction.method),
  #                                        Cell_type=as.factor(my.object$Customized.idents))
  #   my.plot.all.source<-my.plot.all.source[,grep("*\\_[1,2,a-z]",colnames(my.plot.all.source))]
  # }
  # my.plot.source.matchNumber<-match(rownames(my.plot.all.source),rownames(my.plot.regulon))
  # my.plot.source<-cbind.data.frame(my.plot.all.source,regulon.score=my.plot.regulon[my.plot.source.matchNumber,]$regulon.score)
  p.regulon<-ggplot(my.plot.regulon,
                    aes(x=my.plot.regulon[,1],y=my.plot.regulon[,2]))+xlab(colnames(my.plot.regulon)[1])+ylab(colnames(my.plot.regulon)[2])
  p.regulon<-p.regulon+geom_point(aes(col=my.plot.regulon[,"regulon.score"]))+scale_color_gradient(low = "grey",high = "red")
  #p.cluster<-theme_linedraw()
  p.regulon<-p.regulon + labs(col="regulon score")
  message("finish!")
  p.regulon
  

}
Plot.regulon2D(cell.type=1,regulon=5,customized = T)


Get.MarkerGene<-function(customized=T){
  if(customized){
    Idents(my.object)<-my.object$Customized.idents
    my.marker<-FindAllMarkers(my.object,only.pos = T)
  } else {
    Idents(my.object)<-my.object$seurat_clusters
    my.marker<-FindAllMarkers(my.object,only.pos = T)
  }
  my.cluster<-unique(as.character(Idents(my.object)))
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
my.cluster.uniq.marker<-Get.MarkerGene(customized = T)
write.table(my.cluster.uniq.marker,file = "cell_type_unique_marker.txt",quote = F,row.names = F,sep = "\t")

#sad
# regulon genes t-sne



# test plot cluster function. 
Plot.cluster2D(reduction.method = "tsne",customized = T,cell.type=2)# "tsne" ,"pca","umap"
Plot.regulon2D(reduction.method = "tsne",regulon = 12,customized = T,cell.type=1)  




