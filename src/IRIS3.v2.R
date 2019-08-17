
# set working directory, you may change the directory first.
setwd("/fs/project/PAS1475/Yuzhou_Chang/IRIS3/2.Yan/")
# loading required packege
library(Seurat,lib.loc = "/users/PAS1475/cyz931123/R/Seurat/Seurat3.0/")

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

if (!require("dplyr")) {
  install.packages("dplyr")
  library(dplyr)
}

if(!require("DrImpute")){
  install.packages("DrImpute")
  library("DrImpute")
}

if (!require("scran")) {
  BiocManager::install("scran")
  library(scran)
}
if (!require("slingshot")){
  BiocManager::install("slingshot")
  library(slingshot)
}
if (!require("destiny")){
  BiocManager::install("destiny")
}
if(!require(gam)){
  install.packages("gam")
}
#pre-optional
options(stringsAsFactors = F)
options(check.names = F)
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
my.raw.data<-read_data(x = "Yan_expression.txt",sep="\t",read.method = "CellGene")
######################################################
# create Seurat object
my.object<-CreateSeuratObject(my.raw.data)
# check how many cell and genes
dim(my.object)
VlnPlot(my.object, features = c("nFeature_RNA", "nCount_RNA", "percent.mt"), ncol = 3)
plot(log(1:length(my.object$nCount_RNA)),log(sort(my.object$nCount_RNA,decreasing = T)))
#################################################################
# filter some outlier gene, only for 10X data####################
#################################################################


Data.Preprocessing<-function(TenX = FALSE) {
  if(TenX== TRUE){
    my.object[["percent.mt"]] <- PercentageFeatureSet(my.object, pattern = "^MT-")
    my.object <- (subset(my.object, subset = nFeature_RNA > 200 & nFeature_RNA < 3000 & percent.mt < 5))
  }
  return(my.object)
}
my.object<-Data.Preprocessing(TenX = F)
#################################################################
#####################################################
# get data in terms of "counts"(raw data), "data"(normalized data), "scale.data"(scaling the data)
# neglect quality check, may add on in the future

# Key part for customizing cell type: 
##############################################
# Add meta info(cell type) to seurat object###
##############################################
label_data<-read.delim("Yan_cell_label.csv",sep = ",",
                       header = T,check.names = F,stringsAsFactors = F)
my.meta.info<-read.delim("Yan_cell_label.csv",row.names = 1,
                         sep = ",",header = T,check.names = F,stringsAsFactors = F)
my.object<-AddMetaData(my.object,my.meta.info,col.name = "Customized.idents")
# look at current cell type info
Idents(my.object)
# activate customized cell type info
Idents(my.object)<-as.factor(my.object$Customized.idents)

# #######Cankun modification: first imputation, then normalization#########
# 
# my.object<-CreateSeuratObject(expFile)
# #my.object<-GetAssayData(object = my.object,slot = "counts")
# my.count.data<-GetAssayData(object = my.object[['RNA']],slot="counts")
# my.imputated.data <- DrImpute(as.matrix(my.count.data))
# colnames(my.imputated.data)<-colnames(my.count.data)
# rownames(my.imputated.data)<-rownames(my.count.data)
# my.imputated.data<- as.sparse(my.imputated.data)
# 
# sce<-SingleCellExperiment(list(counts=my.imputated.data))
# is.ercc.empty<-function(x) {return(length(grep("^ERCC",rownames(x)))==0)}
# if (is.ercc.empty(sce)){
#   isSpike(sce,"MySpike")<-grep("^ERCC",rownames(sce))
#   sce<-computeSpikeFactors(sce)
# } else {
#   sce<-computeSumFactors(sce)
# }
# 
# #my.object<-NormalizeData(my.object,normalization.method = "LogNormalize",scale.factor = 10000)
# sce <- scater::normalize(sce,return_log=F)
# my.normalized.data <-normcounts(sce)
# my.normalized.data<-log1p(my.normalized.data)
# #######Cankun modification: first imputation, then normalization#########






# get raw data################################  
my.count.data<-GetAssayData(object = my.object[['RNA']],slot="counts")
# normalization##############################
sce<-SingleCellExperiment(list(counts=my.count.data))
# is.ercc<-function(x) {
#   tmp.ercc.index<-grep("^ERCC",ignore.case=T,rownames(x))
#   is.ercc<-length(grep("^ERCC",ignore.case=T,rownames(x)))>0
#   tmp.data<-sce@assays@.xData$data@listData$counts
#   is.exist<-rowSums(tmp.data[grep("^ERCC",ignore.case=T,rownames(x)),]>0) == 0
#   return(is.ercc & is.exist)
#   }
# if (is.ercc(sce)){
#   isSpike(sce,"MySpike")<-grep("^ERCC",ignore.case = T,rownames(sce))
#   sce<-computeSpikeFactors(sce)
# } else {sce<-computeSumFactors(sce)}
sce<-computeSumFactors(sce,positive=T)

sce<-scater::normalize(sce,return_log=F)

my.normalized.data <-sce@assays@.xData$data@listData$normcounts
# imputation#################################

my.imputated.data <- DrImpute(as.matrix(my.normalized.data))
colnames(my.imputated.data)<-colnames(my.count.data)
rownames(my.imputated.data)<-rownames(my.count.data)
my.imputated.data<- as.sparse(my.imputated.data)
my.imputatedLog.data<-log1p(my.imputated.data)
my.object<-SetAssayData(object = my.object,slot = "data",new.data = my.imputatedLog.data,assay="RNA")
#######################################################################
# export data from seurat object.######################################
#######################################################################
my.export.for_LFMG<-GetAssayData(object = my.object,slot = "data")
# you can write table. 
# write.table(my.expression.data,
#             file = "RNA_RAW_EXPRESSION.txt",
#             quote = F,
#             sep = "\t")
#################################
# find high variable gene
my.object<-FindVariableFeatures(my.object,selection.method = "vst",nfeatures = 2000)
# before PCA, scale data to eliminate extreme value affect.
all.gene<-my.object@assays$RNA@var.features
my.object<-ScaleData(my.object,features = all.gene)
# after scaling, perform PCA
my.object<-RunPCA(my.object,rev.pca = F,features = VariableFeatures(object = my.object))
ElbowPlot(object = my.object)
###########################################
# CORE part: Run TSNE and UMAP######################
###########################################
my.object<-RunTSNE(my.object,dims = 1:10,perplexity=10,dim.embed = 3)
# run umap to get high dimension scatter plot at 2 dimensional coordinate system.
# my.object<-RunUMAP(object = my.object,dims = 1:30)
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
## test data, input data path
setwd("/fs/project/PAS1475/Yuzhou_Chang/IRIS3/2019062485208/")
# get cell and regulon information
Get.CellType<-function(cell.type=1,...){
  if(!is.null(cell.type)){
    my.cell.regulon.filelist<-list.files(pattern = "bic.regulon_gene_symbol.txt")
    my.cell.regulon.indicator<-grep(paste0("_",as.character(cell.type),"_bic"),my.cell.regulon.filelist)
    my.cts.regulon.raw<-readLines(my.cell.regulon.filelist[my.cell.regulon.indicator])
    my.regulon.list<-strsplit(my.cts.regulon.raw,"\t")
    return(my.regulon.list)
  }else{stop("please input a cell type")}
  
}
Get.CellType(cell.type = 1)
# get each regulon gene and corresponding expression data. 
Generate.Regulon<-function(cell.type=NULL,regulon=1,...){
  x<-Get.CellType(cell.type = cell.type)
  my.rowname<-rownames(my.object)
  gene.index<-sapply(x[[regulon]][-1],function(x) grep(paste0("^",x,"$"),my.rowname))
  # my.object@data stores normalized data
  tmp.regulon<-my.object@assays$RNA@data[gene.index,]
  return(tmp.regulon)
}
Generate.Regulon(cell.type = 1)

#######################################################
## here you need to calculate Regulon score outside R##
#######################################################


# get Regulon score from external folder. 
Get.RegulonScore<-function(cell.type=1,regulon=1,...){
  # recognize the regulon file pattern.
  tmp.FileList<-list.files(pattern = "regulon_activity_score")
  cell.type.index<-grep(paste0("_CT_",cell.type,"_bic"),tmp.FileList)
  tmp.RegulonScore<-read.delim(tmp.FileList[cell.type.index],sep = "\t",check.names = F)[regulon,]
  tmp.NameIndex<-match(rownames(my.object@reductions$tsne@cell.embeddings),names(tmp.RegulonScore))
  tmp.RegulonScore<-tmp.RegulonScore[tmp.NameIndex]
  tmp.RegulonScore.Numeric<- as.numeric(tmp.RegulonScore)
  my.plot.regulon<-cbind.data.frame(my.object@reductions$tsne@cell.embeddings[,c(1,2)],regulon.score=tmp.RegulonScore.Numeric)
  return(my.plot.regulon)
}


##############################

Plot.cluster2D<-function(customized=F,...){
  if(!customized==TRUE){
    my.plot.all.source<-cbind.data.frame(Embeddings(my.object,reduction = "tsne"),
                                         Cell_type=my.object$seurat_clusters)
  }else{
    my.plot.all.source<-cbind.data.frame(Embeddings(my.object,reduction = "tsne"),
                                         Cell_type=as.factor(my.object$Customized.idents))
  }
  p.cluster<-ggplot(my.plot.all.source,
                    aes(x=my.plot.all.source[,1],y=my.plot.all.source[,2]))+xlab(colnames(my.plot.all.source)[1])+ylab(colnames(my.plot.all.source)[2])
  p.cluster<-p.cluster+geom_point(aes(col=my.plot.all.source[,"Cell_type"]))+scale_color_manual(values  = as.character(palette36.colors(36))[-2])
  #p.cluster<-theme_linedraw()
  p.cluster<-p.cluster + labs(col="cell type")
  p.cluster+theme_light()+scale_fill_continuous(name="cell type") + coord_fixed(1)
  
}

# test plot cluster function. 
Plot.cluster2D(customized = T)

# plot CTS-R
# test Get.RegulonScore, output is matrix


Plot.regulon2D<-function(reduction.method="tsne",regulon=1,cell.type=1,customized=T,...){
  message("plotting regulon ",regulon," of cell type ",cell.type,"...")
  my.plot.regulon<-Get.RegulonScore(reduction.method = reduction.method,
                                    cell.type = cell.type,
                                    regulon = regulon,
                                    customized = customized)

  p.regulon<-ggplot(my.plot.regulon,
                    aes(x=my.plot.regulon[,1],y=my.plot.regulon[,2]))+xlab(colnames(my.plot.regulon)[1])+ylab(colnames(my.plot.regulon)[2])
  p.regulon<-p.regulon+geom_point(aes(col=my.plot.regulon[,"regulon.score"]))+scale_color_gradient(low = "grey",high = "red")
  p.regulon<-p.regulon + labs(col="regulon score") + coord_fixed(1)
  message("finish!")
  p.regulon
  

}
Plot.regulon2D(cell.type=3,regulon=5,customized = T)
Plot.cluster2D(customized = F)

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
Plot.regulon2D(reduction.method = "tsne",regulon = 1,customized = T,cell.type=3)  

# trajectory with slingshot. 

my.trajectory<-SingleCellExperiment(assays=List(counts=my.count.data))
SummarizedExperiment::assays(my.trajectory)$norm<-GetAssayData(object = my.object,assay = "RNA",slot = "data")

# pca <- prcomp(t(SummarizedExperiment::assays(my.trajectory)$norm), scale. = FALSE)
# rd1 <- pca$x[,1:2]
dm<-DiffusionMap(t(as.matrix(SummarizedExperiment::assays(my.trajectory)$norm)))
rd2 <- cbind(DC1 = dm$DC1, DC2 = dm$DC2)
reducedDims(my.trajectory) <- SimpleList( DiffMap = rd2)


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
  par(mar=c(5.1, 4.1, 4.1, 8.1), xpd=TRUE)
  plot(reducedDims(tmp.trajectory.cluster)$DiffMap,
       col=alpha(my.classification.color[as.factor(tmp.trajectory.cluster$cell.label)],0.7),
       pch=20,frame.plot = FALSE,
       asp=1)
  grid()
  tmp.color.cat<-cbind.data.frame(CellName=as.character(tmp.trajectory.cluster$cell.label),
                                  Color=my.classification.color[as.factor(tmp.trajectory.cluster$cell.label)])
  tmp.color.cat<-tmp.color.cat[!duplicated(tmp.color.cat$CellName),]
  tmp.color.cat<-tmp.color.cat[order(as.numeric(tmp.color.cat$CellName)),]
  # add legend
  legend("topright",legend = tmp.color.cat$CellName,
         inset=c(-0.2,0),
         col = tmp.color.cat$Color,pch = 20,
         cex=0.8,title="cluster",bty='n')
  if(add.line==T){
    lines(SlingshotDataSet(tmp.trajectory.cluster), 
          lwd=1,pch=3, col=alpha('black',0.7),
          type="l",show.constraints=show.constraints)
  }
}

Plot.Cluster.Trajectory(customized= T,start.cluster=NULL,add.line = T,end.cluster=NULL,show.constraints=T)

Plot.Regulon.Trajectory<-function(customized=T,cell.type=1,regulon=1,start.cluster=NULL,end.cluster=NULL,...){
  tmp.trajectory.cluster<-Get.cluster.Trajectory(customized = customized,start.cluster=start.cluster,end.cluster=end.cluster)
  tmp.regulon.score<- Get.RegulonScore(cell.type = cell.type,regulon = regulon)
  tmp.cell.name<-colnames(tmp.trajectory.cluster)
  tmp.cell.name.index<-match(tmp.cell.name,rownames(tmp.regulon.score))
  tmp.regulon.score<-tmp.regulon.score[tmp.cell.name.index,]
  val<-tmp.regulon.score$regulon.score
  #
  layout(matrix(1:2,nrow=1),widths=c(0.8,0.2))
  grPal <- colorRampPalette(c("grey","red"))
  tmp.color<-grPal(10)[as.numeric(cut(val,breaks=10))]
  
  par(mar=c(5.1,4.1,4.1,2.1))
  plot(reducedDims(tmp.trajectory.cluster)$DiffMap,
       col=alpha(tmp.color,0.7),
       pch=20,frame.plot = FALSE,
       asp=1)
  grid()
  xl <- 1
  yb <- 1
  xr <- 1.5
  yt <- 2
  
  par(mar=c(5.1,2.1,4.1,0.5))
  plot(NA,type="n",ann=F,xlim=c(1,2),ylim=c(1,2),xaxt="n",yaxt="n",bty="n")
  rect(
    xl,
    head(seq(yb,yt,(yt-yb)/50),-1),
    xr,
    tail(seq(yb,yt,(yt-yb)/50),-1),
    col=grPal(50),border=NA
  )
  tmp.min<-round(min(val),1)
  tmp.Nmean<-round(tmp.min/2,1)
  tmp.max<-round(max(val),1)
  tmp.Pmean<-round(tmp.max/2,1)
  tmp.cor<-seq(yb,yt,(yt-yb)/50)
  mtext(c(tmp.min,tmp.Nmean,0,tmp.Pmean,tmp.max),
                 at=c(tmp.cor[5],tmp.cor[15],tmp.cor[25],tmp.cor[35],tmp.cor[45]),
                 side=2,las=1,cex=0.7)
}
Plot.Regulon.Trajectory(cell.type = 6,regulon = 1,start.cluster = NULL,end.cluster = NULL)


###########################
### gene TSNE plot#########
###########################
# input as normalized data
Plot.GeneTSNE<-function(gene.name=NULL){
  tmp.gene.expression<- my.object@assays$RNA@data
  tmp.dim<-as.data.frame(my.object@reductions$tsne@cell.embeddings)
  tmp.MatchIndex<- match(colnames(tmp.gene.expression),rownames(tmp.dim))
  tmp.dim<-tmp.dim[tmp.MatchIndex,]
  tmp.gene.name<-paste0("^",gene.name,"$")
  tmp.One.gene.value<-tmp.gene.expression[grep(tmp.gene.name,rownames(tmp.gene.expression)),]
  tmp.dim.df<-cbind.data.frame(tmp.dim,Gene=tmp.One.gene.value)
  g<-ggplot(tmp.dim.df,aes(x=tSNE_1,y=tSNE_2,color=Gene))
  g<-g+geom_point()+scale_color_gradient(low="grey",high = "red")
  g<-g+theme_bw()+labs(color=paste0(gene.name,"\nexpression\nvalue")) + coord_fixed(1)
  g
}
Plot.GeneTSNE("CA8")

############


