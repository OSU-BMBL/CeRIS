#######  Plot regulon ##########
#
#library(Seurat)
#library(RColorBrewer)
#library(Polychrome)
#library(ggplot2)

args <- commandArgs(TRUE) 
#setwd("D:/Users/flyku/Documents/IRIS3-data/test_dzscore")
#setwd("/var/www/html/iris3/data/20190802103754")
#srcDir <- getwd()
#id <-"CT4S-R7" 
#jobid <- "20190802103754"
srcDir <- args[1]
id <- args[2]
jobid <- args[3]

Plot.TrajectoryByCellType<-function(customized=T){
  if (customized==TRUE){
    g<-plot_cell_trajectory(cds,color_by = "Customized.idents")
  }
  if (customized==FALSE){
    tmp.colname.phenoData<-colnames(cds@phenoData@data)
    color_by<-grep("^res.*",tmp.colname.phenoData,value = T)[1]
    g<-plot_cell_trajectory(cds,color_by = color_by,cell_size = 2)
  }
  g+scale_color_manual(values  = as.character(palette36.colors(36))[-2])
}

Plot.TrajectoryByRegulon<-function(cell.type=1,regulon=1){
  tmp.FileList<-list.files(pattern = "regulon_activity_score")
  tmp.RegulonScore<-read.delim(tmp.FileList[cell.type],sep = "\t",check.names = F)[regulon,]
  tmp.NameIndex<-match(rownames(cds@phenoData@data),names(tmp.RegulonScore))
  tmp.RegulonScore<-tmp.RegulonScore[tmp.NameIndex]
  tmp.RegulonScore.Numeric<- as.numeric(tmp.RegulonScore)
  cds@phenoData@data$RegulonScore<-tmp.RegulonScore.Numeric
  plot_cell_trajectory(cds,color_by = "RegulonScore",cell_size = 2)+ scale_color_gradient(low = "grey",high = "red")
}


Generate.Regulon<-function(cell.type=NULL,regulon=1,...){
  x<-Get.CellType(cell.type = cell.type)
  my.rowname<-rownames(my.object@data)
  gene.index<-sapply(x[[regulon]][-1],function(x) grep(paste0("^",x,"$"),my.rowname))
  # my.object@data stores normalized data
  tmp.regulon<-my.object@data[,][gene.index,]
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
png(paste("regulon_id/overview_ct.trajectory.png",sep = ""),width=700, height=700)
if (!file.exists(paste("regulon_id/overview_ct.trajectory.png",sep = ""))){
  #Plot.cluster2D(reduction.method = "tsne",customized = T)
  #Plot.TrajectoryByCellType(customized = T)
  if(!exists("cds")){
    library(monocle)
    cds <- readRDS("monocle_obj.rds")
  }
  plot_cell_trajectory(cds,color_by="Customized.idents")
}
quiet(dev.off())

png(paste("regulon_id/",id,".trajectory.png",sep = ""),width=700, height=700)
if (!file.exists(paste("regulon_id/",id,".trajectory.png",sep = ""))){
  if(!exists("cds")){
    library(monocle)
    cds <- readRDS("monocle_obj.rds")
  }
  Plot.TrajectoryByRegulon(cell.type = as.numeric(regulon_ct),regulon = as.numeric(regulon_id))
}
quiet(dev.off())


