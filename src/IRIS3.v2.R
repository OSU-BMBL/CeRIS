
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
# if (!require("AUCell")) {
#   BiocManager::install("AUCell")
#   library(AUCell)
# }
if (!require("dplyr")) {
  install.packages("dplyr")
  library(dplyr)
}
# if(!require("Rmagic")){
#   install.packages("Rmagic")
#   library("Rmagic")
#   install.magic(envname = "r-reticulate", 
#                 method = "auto",
#                 conda = "auto", pip = TRUE)
# }
if(!require("DrImpute")){
  install.packages("DrImpute")
  library("DrImpute")
}

if (!require("scran")) {
  BiocManager::install("scran")
  library(scran)
}
if (!require("slingshot")){
  BiocManager::install("kstreet13/slingshot")
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
my.raw.data<-read_data(x = "Yan_expression.csv",sep=",",read.method = "CellGene")
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
# my.expression.data<-GetAssayData(object = my.object,slot = "counts")
# write.table(my.expression.data,
#             file = "RNA_RAW_EXPRESSION.txt",
#             quote = F,
#             sep = "\t")
#################################

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
# get raw data################################  
my.count.data<-GetAssayData(object = my.object[['RNA']],slot="counts")
# normalization##############################
sce<-SingleCellExperiment(list(counts=my.count.data))
is.ercc.empty<-function(x) {return(length(grep("^ERCC",rownames(x)))==0)}
if (is.ercc.empty(sce)){
  isSpike(sce,"MySpike")<-grep("^ERCC",rownames(sce))
  sce<-computeSpikeFactors(sce)
} else {sce<-computeSumFactors(sce)}

sce<-scater::normalize(sce,return_log=F)

my.normalized.data <-sce@assays@.xData$data@listData$normcounts
# imputation#################################

my.imputated.data <- DrImpute(as.matrix(my.normalized.data))
colnames(my.imputated.data)<-colnames(my.count.data)
rownames(my.imputated.data)<-rownames(my.count.data)
my.imputated.data<- as.sparse(my.imputated.data)
my.imputatedLog.data<-log1p(my.imputated.data)
my.object<-SetAssayData(object = my.object,slot = "data",new.data = my.imputatedLog.data,assay="RNA")
#my.object<-NormalizeData(my.object,normalization.method = "LogNormalize",scale.factor = 10000)
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

# Generate.Regulon<-function(cell.type=NULL,regulon=1,...){
#   x<-Get.CellType(cell.type = cell.type)
#   tmp.regulon<-subset(my.object,cells = colnames(my.object),features = x[[regulon]][-1])
#   return(tmp.regulon)
# }
# Generate.Regulon(cell.type = 1,regulon = 1)
# read in motif score and 
# next step will take 1min to generate the mixed matrix

# cells_rankings<-AUCell_buildRankings(my.object@assays$RNA@data)


# Get.RegulonScore<-function(reduction.method="tsne",cell.type=1,regulon=1,customized=F,...){
#   my.regulon.number<-length(Get.CellType(cell.type = cell.type))
#   if (regulon > my.regulon.number){
#     stop(paste0("Regulon number exceeds the boundary. Under this cell type, there are total ", my.regulon.number," regulons"))
#   } else {
#     my.cts.regulon.S4<-Generate.Regulon(cell.type = cell.type,regulon=regulon)
#     if(customized){
#       my.cell.type<-my.cts.regulon.S4$Customized.idents
#       message(c("using customized cell label: ","|", paste0(unique(as.character(my.cts.regulon.S4$Customized.idents)),"|")))
#     }else{
#       my.cell.type<-my.cts.regulon.S4$seurat_clusters
#       message(c("using default cell label(seurat prediction): ","|", paste0(unique(as.character(my.cts.regulon.S4$seurat_clusters)),"|")))
#     } 
#     tmp_data<-as.data.frame(my.cts.regulon.S4@assays$RNA@data)
#     geneSets<-list(GeneSet1=rownames(tmp_data))
#     cells_AUC<-AUCell_calcAUC(geneSets,cells_rankings,aucMaxRank = nrow(cells_rankings)*0.05)
#     cells_assignment<-AUCell_exploreThresholds(cells_AUC,plotHist = T,nCores = 1,assign = T)
#     my.auc.data<-as.data.frame(cells_AUC@assays@.xData$data$AUC)
#     my.auc.data<-t(my.auc.data[,colnames(tmp_data)])
#    # regulon.score<-colMeans(tmp_data)/apply(tmp_data,2,sd)
#     regulon.score<-my.auc.data
#     tmp.embedding<-Embeddings(my.object,reduction = reduction.method)[colnames(my.cts.regulon.S4),][,c(1,2)]
#     my.choose.regulon<-cbind.data.frame(tmp.embedding,Cell_type=my.cell.type,
#                                         regulon.score=regulon.score[,1])
#     
#     return(my.choose.regulon)
#   }
# }
# Get.RegulonScore(reduction.method = "tsne",cell.type = 2,regulon = 1,customized = T)
##############################

Plot.cluster2D<-function(customized=F,...){
  # my.plot.source<-GetReduceDim(reduction.method = reduction.method,module = module,customized = customized)
  # my.module.mean<-colMeans(my.gene.module[[module]]@assays$RNA@data)
  # my.plot.source<-cbind.data.frame(my.plot.source,my.module.mean)
  if(!customized){
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
  p.regulon<-p.regulon + labs(col="regulon score") + coord_fixed(1)
  message("finish!")
  p.regulon
  

}
Plot.regulon2D(cell.type=3,regulon=5,customized = T)
Plot.cluster2D(customized = T)

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

pca <- prcomp(t(SummarizedExperiment::assays(my.trajectory)$norm), scale. = FALSE)
rd1 <- pca$x[,1:2]
dm<-DiffusionMap(t(as.matrix(SummarizedExperiment::assays(my.trajectory)$norm)))
rd2 <- cbind(DC1 = dm$DC1, DC2 = dm$DC2)
reducedDims(my.trajectory) <- SimpleList(PCA = rd1, DiffMap = rd2)


Get.cluster.Trajectory<-function(customized=T,start.cluster=NULL,end.cluster=NULL,...){
  #labeling cell
  if(customized==TRUE){
    tmp.cell.type<-my.object$Customized.idents
  }
  if(customized==FALSE){
    tmp.cell.type<-my.object$seurat_clusters
  }
  tmp.cell.name.index<-match(colnames(my.trajectory),names(tmp.cell.type))
  tmp.cell.type<-tmp.cell.type[tmp.cell.name.index]
  colData(my.trajectory)$cell.label<-tmp.cell.type
  # run trajectory, first run the lineage inference
  my.trajectory <- slingshot(my.trajectory, clusterLabels = 'cell.label', reducedDim = 'DiffMap',
                             start.clus=start.cluster,end.clus=end.cluster)
  #summary(my.trajectory$slingPseudotime_1)
  return(my.trajectory)
}

Plot.Cluster.Trajectory<-function(customized=T,start.cluster=NULL,end.cluster=NULL,show.constraints=F,...){
  tmp.trajectory.cluster<-Get.cluster.Trajectory(customized = customized,start.cluster=start.cluster,end.cluster=end.cluster)
  my.classification.color<-as.character(palette36.colors(36))[-2]
  plot(reducedDims(tmp.trajectory.cluster)$DiffMap,col=alpha(my.classification.color[tmp.trajectory.cluster$cell.label],0.7),pch=20,asp=1)
  lines(SlingshotDataSet(tmp.trajectory.cluster), lwd=1,pch=3, col=alpha('black',0.7),type="l",show.constraints=T)

}
Plot.Cluster.Trajectory(start.cluster=1,end.cluster=7,show.constraints=T)

Plot.Regulon.Trajectory<-function(customized=T,cell.type=1,regulon=1,start.cluster=NULL,end.cluster=NULL,...){
  tmp.trajectory.cluster<-Get.cluster.Trajectory(customized = customized,start.cluster=start.cluster,end.cluster=end.cluster)
  tmp.regulon.score<- Get.RegulonScore(cell.type = cell.type,regulon = regulon)
  tmp.cell.name<-names(tmp.trajectory.cluster$cell.label)
  tmp.cell.name.index<-match(tmp.cell.name,rownames(tmp.regulon.score))
  tmp.regulon.score<-tmp.regulon.score[tmp.cell.name.index,]
  val<-tmp.regulon.score$regulon.score
  grPal<-colorRampPalette(c('grey','red'))
  tmp.color<-grPal(10)[as.numeric(cut(val,breaks=10))]
  plot(reducedDims(tmp.trajectory.cluster)$DiffMap,col=alpha(tmp.color,0.8),pch=20,asp=1)
  lines(SlingshotDataSet(tmp.trajectory.cluster))
}
Plot.Regulon.Trajectory(cell.type = 6,regulon = 1,start.cluster = 1,end.cluster = 7)

######color indicator#############################################
color.bar <- function(val, min, max=-min, nticks=11, ticks=seq(min, max, len=nticks), title='') {
  scale = round((length(val)-1)/(max-min),0)
  dev.new(width=1.75, height=5)
  plot(c(0,10), c(min,max), type='n', bty='n', xaxt='n', xlab='', yaxt='n', ylab='', main=title)
  axis(2, ticks, las=1)
  for (i in 1:(length(val)-1)) {
    y = (i-1)/scale + min
    rect(0,y,10,y+1/scale, col=val[i], border=NA)
  }	
}

val.around<- round(val,digits = 1)
color.bar(val.around,min=min(val.around),max=max(val.around))



###########################
###########################
### gene TSNE plot#########
###########################
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
  g<-g+theme_bw()+labs(color=paste0(gene.name,"\nexpression\nvalue"))
  g
}
Plot.GeneTSNE("CA8")



