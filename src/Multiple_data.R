setwd("/fs/project/PAS1475/Yuzhou_Chang/IRIS3/test_data/Seurat_multiple_data/immuno_cell/")

pancreas.data <- readRDS(file = "pancreas_expression_matrix.rds")
metadata <- readRDS(file = "pancreas_metadata.rds")
# mode1 input before merge, user need upload meta file.
pancreas <- CreateSeuratObject(pancreas.data, meta.data = metadata)
pancreas.list <- SplitObject(pancreas, split.by = "tech")

rundata<-function(){
  tmp.object<-FindVariableFeatures(tmp.object,selection.method = "vst",nfeatures = 2000)
  all.gene<-tmp.object@assays$RNA@var.features
  tmp.object<-ScaleData(tmp.object,features = all.gene)
  
}

read.multipledata<-function(Path=getwd()){
  # mode2 input individual files.
  current.path<-getwd()
  tmp.path<-Path
  setwd(tmp.path)
  my.file<- list.files(pattern = ".h5")
  my.data.list<-list()
  for(i in 1:length(my.file)){
    tmp.raw.data<-read_data(my.file[i],read.method = "TenX.h5")
    tmp.object<-CreateSeuratObject(tmp.raw.data)
    tmp.object[["percent.mt"]] <- PercentageFeatureSet(tmp.object, pattern = "^MT-")
    tmp.object <- (subset(tmp.object, subset = nFeature_RNA > 200 & nFeature_RNA < 3000 & percent.mt < 5))
    sce<-SingleCellExperiment(list(counts=my.count.data))
    my.count.data<-GetAssayData(object = tmp.object[['RNA']],slot="counts")
    if(all(as.numeric(unlist(my.count.data[nrow(my.count.data),]))%%1==0)){
      ## normalization##############################
      sce <- tryCatch(computeSumFactors(sce),error = function(e) computeSumFactors(sce, sizes=seq(21, 201, 5)))
      sce<-scater::normalize(sce,return_log=F)
      my.normalized.data <- normcounts(sce)
    } else {
      my.normalized.data <- my.count.data
    }
    
    sce<-computeSumFactors(sce,positive=T)
    sce<-scater::normalize(sce,return_log=F)
    my.normalized.data <-sce@assays@.xData$data@listData$normcounts
    my.imputated.data <- DrImpute(as.matrix(my.normalized.data),ks=12,dists = "spearman")
    colnames(my.imputated.data)<-colnames(my.count.data)
    rownames(my.imputated.data)<-rownames(my.count.data)
    my.imputated.data<- as.sparse(my.imputated.data)
    my.imputatedLog.data<-log1p(my.imputated.data)
    tmp.object<-SetAssayData(object = tmp.object,slot = "data",new.data = my.imputatedLog.data,assay="RNA")
    my.data.list<-append(my.data.list,tmp.object)
  }
  names(my.data.list)<-my.file
  setwd(current.path)
}
##########################################
# integrate:
my.anchor<-FindIntegrationAnchors(object.list = my.data.list, dims = 1:30)
my.integrated <- IntegrateData(anchorset = my.anchor, dims = 1:30)












