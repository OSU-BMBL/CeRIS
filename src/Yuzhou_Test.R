setwd("/fs/project/PAS1475/Yuzhou_Chang/IRIS3/test_data/20190830171050//")
my.object<-readRDS("seurat_obj.rds")
my.ltmg<-read.delim("20190830171050_filtered_expression.txt.em.chars",header = T)
my.ltmg2<-read.csv("LTMG.matrix.csv",header = T,sep = ",")
my.ltmg.line<-readLines("20190830171050_filtered_expression.txt.em.chars")
my.ltmg.pure<-my.ltmg[-which(duplicated(my.ltmg$o)==T),1:5]

rownames(my.ltmg.pure)<-my.ltmg.pure$o
my.ltmg.pure<-my.ltmg.pure[,-1]


my.object@assays$RNA@data<-as.sparse(my.ltmg.pure)

my.object<-FindVariableFeatures(my.object,selection.method = "vst",nfeatures = 2000)
all.gene<-my.object@assays$RNA@var.features
my.object<-ScaleData(my.object,features = all.gene)
my.object<-RunPCA(my.object,rev.pca = F,features = VariableFeatures(object = my.object))
# ElbowPlot(object = my.object)
my.object<-RunTSNE(my.object,dims = 1:10,perplexity=10,dim.embed = 3)
my.object<-RunUMAP(my.object,dims=1:10)
# my.object<-FindNeighbors(my.object,k.param = 20,dims = 1:30)
# my.object<-FindClusters(my.object,resolution = 0.5)
# plot
activity_score <- read.table(paste(jobid,"_CT_",4,"_bic.regulon_activity_score.txt",sep = ""),row.names = 1,header = T,check.names = F)
Plot.cluster2D(customized = T,pt_size = pt_size)
Plot.regulon2D(reduction.method = "umap",regulon = 1,customized = T,cell.type=4,pt_size = pt_size)
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

