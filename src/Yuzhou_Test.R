setwd("/fs/project/PAS1475/Yuzhou_Chang/IRIS3/test_data/11.Klein/20190818121919/")
my.object<-readRDS("seurat_obj.rds")
my.object<-FindVariableFeatures(my.object,selection.method = "vst",nfeatures = 2000)
all.gene<-my.object@assays$RNA@var.features
my.object<-ScaleData(my.object,features = all.gene)
my.object<-RunPCA(my.object,rev.pca = F,features = VariableFeatures(object = my.object))
ElbowPlot(object = my.object)
my.object<-RunTSNE(my.object,dims = 1:10,perplexity=10,dim.embed = 3)
my.object<-FindNeighbors(my.object,k.param = 20,dims = 1:30)
my.object<-FindClusters(my.object,resolution = 0.5)
# plot
Plot.cluster2D(customized = T)
Plot.regulon2D(reduction.method = "tsne",regulon = 1,customized = T,cell.type=3)
#####
my.RAS.filelist<-list.files(pattern = "_activity_score.txt")
my.order<- sapply(strsplit(my.RAS.filelist,"_"),"[",3)
my.regulon.cell.Matrix<-c()
for(i in 1:length(my.RAS.filelist)){
  tmp.file.index<-grep(my.order[i],paste0("_CT",my.order[i],"_bic.regulon_activity_score.txt$"))
  tmp.x<-read.delim(my.RAS.filelist[tmp.file.index])
  rownames(tmp.x)<-paste0("CT_",my.order[i],"_Regulon","_",1:nrow(tmp.x))
  my.regulon.cell.Matrix<-rbind.data.frame(my.regulon.cell.Matrix,tmp.x)
}
my.count.data<-my.object@assays$RNA@data
my.trajectory<-SingleCellExperiment(assays=List(counts=my.count.data))
reducedDims(my.trajectory)<-Dim.Calculate(Matrix.type="GEM")

Plot.Cluster.Trajectory(customized= T,start.cluster=NULL,add.line = T,end.cluster=NULL,show.constraints=T)

