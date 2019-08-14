#######  Plot regulon ##########
#
#library(Seurat)
library(RColorBrewer)
library(Polychrome)
library(ggplot2)

args <- commandArgs(TRUE) 
#setwd("D:/Users/flyku/Documents/IRIS3-data/test_dzscore")
#setwd("/var/www/html/iris3/data/20190802103754")
#srcDir <- getwd()
#id <-"CT4S-R7" 
#jobid <- "20190802103754"
srcDir <- args[1]
id <- args[2]
jobid <- args[3]

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

Generate.Regulon<-function(cell.type=NULL,regulon=1,...){
  x<-Get.CellType(cell.type = cell.type)
  tmp.regulon<-subset(my.object,cells = colnames(my.object),features = x[[regulon]][-1])
  return(tmp.regulon)
}

Get.CellType<-function(cell.type=NULL,...){
  if(!is.null(cell.type)){
    my.cell.regulon.filelist<-list.files(pattern = "bic.regulon_gene_symbol.txt")
    my.cell.regulon.indicator<-grep(paste0("_",as.character(cell.type),"_bic"),my.cell.regulon.filelist)
    my.cts.regulon.raw<-readLines(my.cell.regulon.filelist[my.cell.regulon.indicator])
    my.regulon.list<-strsplit(my.cts.regulon.raw,"\t")
    return(my.regulon.list)
  }else{stop("please input a cell type")}
  
}



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
      my.cell.type<-as.numeric(my.cts.regulon.S4$seurat_clusters) 
      message(c("using default cell label(seurat prediction): ","|", paste0(unique(as.character(my.cts.regulon.S4$seurat_clusters)),"|")))
    } 
    tmp_data<-as.data.frame(my.cts.regulon.S4@assays$RNA@data)
    geneSets<-list(GeneSet1=rownames(tmp_data))
    #cells_AUC<-AUCell_calcAUC(geneSets,cells_rankings,aucMaxRank = nrow(cells_rankings)*0.1)
    #cells_assignment<-AUCell_exploreThresholds(cells_AUC,plotHist = F,nCores = 1,assign = T)
    #my.auc.data<-as.data.frame(cells_AUC@assays@.xData$data$AUC)
    #my.auc.data<-t(my.auc.data[,colnames(tmp_data)])
    #regulon.score<-colMeans(tmp_data)/apply(tmp_data,2,sd)
    regulon.score<-t(as.matrix(activity_score[regulon,]))
    tmp.embedding<-Embeddings(my.object,reduction = reduction.method)[colnames(my.cts.regulon.S4),][,c(1,2)]
    my.choose.regulon<-cbind.data.frame(tmp.embedding,Cell_type=my.cell.type)
    my.choose.regulon <- cbind(my.choose.regulon, regulon.score=regulon.score[match(rownames(my.choose.regulon), rownames(regulon.score))])
    
    return(my.choose.regulon)
  }
}

quiet <- function(x) {
  sink(tempfile()) 
  on.exit(sink()) 
  invisible(force(x)) 
} 

setwd(srcDir)

regulon_ct <-gsub( "-.*$", "", id)
regulon_ct <-gsub("[[:alpha:]]","",regulon_ct)
regulon_id <- gsub( ".*R", "", id)
regulon_id <- gsub("[[:alpha:]]","",regulon_id)

activity_score <- read.table(paste(jobid,"_CT_",regulon_ct,"_bic.regulon_activity_score.txt",sep = ""),row.names = 1,header = T,check.names = F)
png(paste("regulon_id/overview_ct.trajectory.png",sep = ""),width=1600, height=1200,res = 300)
if (!file.exists(paste("regulon_id/overview_ct.trajectory.png",sep = ""))){
  #Plot.cluster2D(reduction.method = "tsne",customized = T)
  #Plot.TrajectoryByCellType(customized = T)
  if(!exists("cds")){
    library(slingshot)
    cds <- readRDS("trajectory_obj.rds")
  }
  Plot.Cluster.Trajectory(start.cluster=1,end.cluster=7,show.constraints=T)
}
quiet(dev.off())

png(paste("regulon_id/",id,".trajectory.png",sep = ""),width=1600, height=1200,res = 300)
if (!file.exists(paste("regulon_id/",id,".trajectory.png",sep = ""))){
  if(!exists("cds")){
    library(monocle)
    cds <- readRDS("trajectory_obj.rds")
  }
  
  Plot.Regulon.Trajectory(cell.type = as.numeric(regulon_ct),regulon = as.numeric(regulon_id),start.cluster = 1,end.cluster = 7)
  
}
quiet(dev.off())


