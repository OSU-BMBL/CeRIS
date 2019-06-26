#######  Plot regulon ##########
if(!require(Seurat)) {
  install.packages("Seurat")
} 

if (!require("RColorBrewer")) {
  install.packages("RColorBrewer")
}
if (!require("Polychrome")) {
  install.packages("Polychrome")
  library(Polychrome)
}
library(AUCell)
args <- commandArgs(TRUE)
#setwd("D:/Users/flyku/Documents/IRIS3-data/test_zscore")
#setwd("C:/Users/wan268/Documents/iris3_data/0624")
#srcDir <- getwd()
#id <-"CT1S-R3" 
srcDir <- args[1]
id <- args[2]


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
  p.regulon<-p.regulon+geom_point(aes(col=my.plot.regulon[,"regulon.score"]))+scale_color_gradient(low = "white",high = "red")
  #p.cluster<-theme_linedraw()
  p.regulon<-p.regulon + labs(col="regulon score")
  message("finish!")
  p.regulon
  
  
}

Generate.Regulon<-function(cell.type=NULL,regulon=1,...){
  x<-Get.CellType(cell.type = cell.type)
  tmp.regulon<-subset(my.object,cells = colnames(my.object),features = x[[regulon]][-1])
  return(tmp.regulon)
}

Get.CellType<-function(cell.type=NULL,...){
  if(!is.null(cell.type)){
    my.cell.regulon.filelist<-list.files(pattern = "bic.regulon_gene_name.txt")
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
      my.cell.type<-my.cts.regulon.S4$seurat_clusters
      message(c("using default cell label(seurat prediction): ","|", paste0(unique(as.character(my.cts.regulon.S4$seurat_clusters)),"|")))
    } 
    tmp_data<-as.data.frame(my.cts.regulon.S4@assays$RNA@data)
    geneSets<-list(GeneSet1=rownames(tmp_data))
    cells_AUC<-AUCell_calcAUC(geneSets,cells_rankings,aucMaxRank = nrow(cells_rankings)*0.5)
    #cells_assignment<-AUCell_exploreThresholds(cells_AUC,plotHist = F,nCores = 1,assign = T)
    my.auc.data<-as.data.frame(cells_AUC@assays@.xData$data$AUC)
    my.auc.data<-t(my.auc.data[,colnames(tmp_data)])
    # regulon.score<-colMeans(tmp_data)/apply(tmp_data,2,sd)
    regulon.score<-my.auc.data
    tmp.embedding<-Embeddings(my.object,reduction = reduction.method)[colnames(my.cts.regulon.S4),][,c(1,2)]
    my.choose.regulon<-cbind.data.frame(tmp.embedding,Cell_type=my.cell.type,
                                        regulon.score=regulon.score[,1])
    return(my.choose.regulon)
  }
}
quiet <- function(x) { 
  sink(tempfile()) 
  on.exit(sink()) 
  invisible(force(x)) 
} 


setwd(srcDir)
my.object <- readRDS("seurat_obj.rds")
cells_rankings<-quiet(AUCell_buildRankings(my.object@assays$RNA@data))

regulon_ct <-gsub( "-.*$", "", id)
regulon_ct <-gsub("[[:alpha:]]","",regulon_ct)
regulon_id <- gsub( ".*R", "", id)
regulon_id <- gsub("[[:alpha:]]","",regulon_id)
#save.image(file="plot_regulon.RData")

png(paste("regulon_id/overview_",id,".png",sep = ""),width=700, height=700)
Plot.cluster2D(reduction.method = "tsne",customized = T)
quiet(dev.off())

png(paste("regulon_id/",id,".png",sep = ""),width=700, height=700)
Plot.regulon2D(reduction.method = "tsne",regulon = as.numeric(regulon_id),cell.type=as.numeric(regulon_ct),customized =T)  
quiet(dev.off())


