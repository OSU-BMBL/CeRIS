# set working directory, you may change the directory first.
setwd("/home/cyz/Bigstore/BigData/runningdata/outs")
#setwd("/var/www/html/iris3/data/20190528122627")
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
  #install.packages("Polychrome")
  library(Polychrome)
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
# read.data function:#
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
Idents(my.object)
Idents(my.object)<-my.object$Customized.idents
##############################################

my.object<-NormalizeData(my.object,normalization.method = "LogNormalize",scale.factor = 10000)
my.object<-FindVariableFeatures(my.object,selection.method = "vst",nfeatures = 5000)
VariableFeaturePlot(my.object)
# before PCA, scale data to eliminate extreme value affect.
all.gene<-rownames(my.object)
my.object<-ScaleData(my.object,features = all.gene)
# after scaling, perform PCA
my.object<-RunPCA(my.object,rev.pca = F,features = VariableFeatures(object = my.object))
DimPlot(my.object,reduction = "pca")
# Elbowplot help to choose "dim" 
ElbowPlot(my.object,ndims = 30)
###########################################
# CORE part: Run TSNE######################
###########################################
my.object<-RunTSNE(my.object,dims = 1:15,perplexity=10,dim.embed = 3)
DimPlot(my.object,reduction = "tsne")
# run umap to get high dimension scatter plot at 2 dimensional coordinate system.
my.object<-RunUMAP(object = my.object,dims = 1:20)
DimPlot(my.object,reduction = "umap")
# clustering by using KNN, this is seurat cluster algorithm, this part only for cell categorization
my.object<-FindNeighbors(my.object,k.param = 6,dims = 1:20)
# find clustering, there will be changing the default cell type, if want to use customized cell type. 
# use Idents() function.
my.object<-FindClusters(my.object,resolution = 0.5)
head(Idents(my.object),10)
DimPlot(my.object,reduction = "umap")
## umap based on input string, this ident could be automatically regonized by cell name from input cell-gene matrix.
# in the seurat, the original category stores in orig.ident
Idents(my.object)<-my.object$orig.ident
DimPlot(my.object,reduction = "umap")
# find marker gene based on string category, find marker gene based on the classified ident (could be customized). 
cluster.oocyte<-FindMarkers(my.object,ident.1 = "OoCyte",min.pct = 0.25)
head(cluster.oocyte)
VlnPlot(my.object,features = c("OR2T4","RLN1","C1orf146"))
# mark out the gene based on classified information
FeaturePlot(my.object,features = c("OR2T4","RLN1","C1orf146"))
# create gene Module, please provide a creat module format!
# M1  M2  M3.....#
# G1  G2  G3.....#
# G4  G5  G6.....#
#----------------#
# my.module.name<-read.table("BRIC_Module.txt",stringsAsFactors = F) # read gene module,refer to gene module extraction code in BRIC. 
# my.module.number<-ncol(my.module.name) 
# colnames(my.module.name)<-paste0("Module_BC_",seq(1:ncol(my.module.name)))
# my.module.name<-apply(my.module.name,2,na.omit)
# call.value<-function(x){
#   my.value<-c()
#   for(i in 1:length(x)){
#     tmp<-grep(paste0("^",x[i],"$"),row.names(my.object))
#     my.value<-c(my.value,tmp)
#   }
#   return(my.value)
# }
# my.module.location<-lapply(my.module.name,call.value)
# my.module.value<-matrix(NA,nrow =my.module.number,ncol = dim(my.object)[2])
# rownames(my.module.value)<-names(my.module.name)
# colnames(my.module.value)<-colnames(my.object)
# my.raw.data<-my.object@assays$RNA@counts
# my.raw.data<-my.raw.data[,colnames(my.module.value)]
# 
# for(j in 1:nrow(my.module.value)){
#     tmp.value<-my.normalized.data[my.module.location[[j]],]
#     tmp.average<-colMeans(tmp.value)
#     my.module.value[j,]<-tmp.average    
# }
# 
# my.tsne<-cbind(my.tsne[,1:3],Cell_Type=my.object@meta.data$BRIC.idents,t(my.module.value))


# extract cell and gene module from qubic2 output
my.file<-list.files(pattern = ".chars.blocks")
my.blocks<-readLines(my.file)
my.cond<-grep('Conds',my.blocks,value = T)
my.cell.names<-sapply(strsplit(my.cond,":",2),"[",2)
my.gene<-grep('Genes',my.blocks,value = T)
my.gene.names<-sapply(strsplit(my.gene,":",2),"[",2)
my.gene.module<-list()
for(i in 1:length(my.cell.names)){
  cell.name.tmp<-my.cell.names[[i]]
  cell.name.tmp<-unlist(strsplit(cell.name.tmp,split = " "))
  cell.name.tmp<-cell.name.tmp[cell.name.tmp!=""]
  gene.name.tmp<-my.gene.names[[i]]
  gene.name.tmp<-unlist(strsplit(gene.name.tmp,split = " "))
  gene.name.tmp<-gene.name.tmp[gene.name.tmp!=""]
  gene.name.tmp<-gsub("\\_[-1,0-9]+$","",gene.name.tmp)
  gene.name.tmp<-unique(gene.name.tmp)
  my.subset<-subset(my.object,
                    cell=cell.name.tmp,
                    features=gene.name.tmp)
  my.gene.module<-append(my.gene.module,my.subset)
  print(paste0("complete to merge ",i,"th gene module!"," Total: ",length(my.cell.names)))
}

# call tnse or umap axis from seurat.
GetReduceDim<-function(reduction.method='tsne',module=1,customized=T){
  if(is.null(module)|!is.numeric(module)){ stop("please give the gene module number")}
  else if(is.null(reduction.method)){stop("please enter the 'pca','tsne',or 'umap' as a dimensional reduction method.")}
  else {  
        my.count<-my.gene.module[[module]]@assays$RNA@data
         if(!customized){
             my.cluster<-my.gene.module[[module]]@meta.data$seurat_clusters
             if(reduction.method=="pca"){
               return(cbind.data.frame(my.gene.module[[module]]@reductions$pca@cell.embeddings[,1:3],Cell_type=my.cluster))
             } else if(reduction.method=="tsne"){
               return(cbind.data.frame(my.gene.module[[module]]@reductions$tsne@cell.embeddings[,1:3],Cell_type=my.cluster))
             } else if(reduction.method=="umap"){
               return(cbind.data.frame(my.gene.module[[module]]@reductions$umap@cell.embeddings[,1:2],Cell_type=my.cluster))
             } else{stop("Unregonized reducntoin method, please enter one of 'pca','tsne',or 'umap'")}
         } else{
               my.cluster<-my.gene.module[[module]]@meta.data$Customized.idents
               if(reduction.method=="pca"){
                 return(cbind.data.frame(my.gene.module[[module]]@reductions$pca@cell.embeddings[,1:3]),Cell_type=my.cluster)
               } else if(reduction.method=="tsne"){
                 return(cbind.data.frame(my.gene.module[[module]]@reductions$tsne@cell.embeddings[,1:3],Cell_type=my.cluster))
               } else if(reduction.method=="umap"){
                 return(cbind.data.frame(my.gene.module[[module]]@reductions$umap@cell.embeddings[,1:2],Cell_type=my.cluster))
               } else{stop("Unregonized reducntoin method, please enter one of 'pca','tsne',or 'umap'")}
             }
         }
}
 
# test

GetReduceDim(reduction.method = "umap",module = 55,customized = F)

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
# input website CTS-R under a specific cell type
  # in this example I let my.cts.regulon read in specific cell type 1 
  my.cts.regulon.raw<-readLines("2019052895653_CT_1_bic.regulon_gene_name.txt")
  my.regulon.number<-length(my.cts.regulon.raw)
  my.regulon.list<-strsplit(my.cts.regulon.raw,"\t")
  # next step will take 1min to generate the mixed matrix
  my.cts.regulon<-c()
  for (i in 1:my.regulon.number){
    my.cts.regulon.tmp<-subset(my.object,cells = colnames(my.object),features = my.regulon.list[[i]][-1])
    my.cts.regulon<-append(my.cts.regulon,my.cts.regulon.tmp)
    print(paste0("Finished to merge the ",i,"th regulon"))
  }
  
  
  Get.RegulonScore<-function(reduction.method="tsne",regulon=1,...){
    if (regulon > my.regulon.number){
      stop(paste0("Regulon number exceeds the boundary. Under this cell type, there are total", my.regulon.number,"regulons"))
    } else {
      regulon.score<-colMeans(my.cts.regulon[[regulon]]@assays$RNA@data)
      tmp.embedding<-Embeddings(my.object,reduction = reduction.method)[colnames(my.cts.regulon[[regulon]]),][,c(1,2)]
      my.choose.regulon<-cbind.data.frame(tmp.embedding,
                                          regulon.score)
      return(my.choose.regulon)
    }
  }
# test Get.RegulonScore, output is matrix
  
  
  Plot.regulon2D<-function(reduction.method="tsne",regulon=1,customized=F,...){
    my.plot.regulon<-Get.RegulonScore(reduction.method = reduction.method,regulon = regulon)
    if(!customized){
      my.plot.all.source<-cbind.data.frame(Embeddings(my.object,reduction = reduction.method),
                                           Cell_type=my.object$seurat_clusters)
      my.plot.all.source<-my.plot.all.source[,grep("*\\_[1,2,a-z]",colnames(my.plot.all.source))]
    }else{
      my.plot.all.source<-cbind.data.frame(Embeddings(my.object,reduction = reduction.method),
                                           Cell_type=as.factor(my.object$Customized.idents))
      my.plot.all.source<-my.plot.all.source[,grep("*\\_[1,2,a-z]",colnames(my.plot.all.source))]
    }
    my.plot.all.source.new.matchNumber<-match(rownames(my.plot.all.source),rownames(my.plot.regulon))
    my.plot.all.source.new<-cbind.data.frame(my.plot.all.source,my.plot.regulon[my.plot.all.source.new.matchNumber,])
    my.plot.all.source.new<-my.plot.all.source.new[,c(-4,-5)]
    p.regulon<-ggplot(my.plot.all.source.new,
                      aes(x=my.plot.all.source.new[,1],y=my.plot.all.source.new[,2]))+xlab(colnames(my.plot.all.source.new)[1])+ylab(colnames(my.plot.all.source.new)[2])
    p.regulon<-p.regulon+geom_point(aes(col=my.plot.all.source.new[,"regulon.score"]))+scale_color_gradient(low = "blue",high = "red")
    #p.cluster<-theme_linedraw()
    p.regulon<-p.regulon + labs(col="regulon score")
    p.regulon
    
  }
  
  # test plot cluster function. 
  Plot.cluster2D(reduction.method = "tsne",customized = T)# "tsne" ,"pca","umap"
  Plot.regulon2D(reduction.method = "tsne",regulon = 14,customized =T)

  
  
  
