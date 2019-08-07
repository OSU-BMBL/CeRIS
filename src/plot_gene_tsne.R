#######  Plot gene expression value for a gene in tsne map##########

#library(Seurat)
#library(RColorBrewer)
#library(Polychrome)
#library(ggplot2)
#library(monocle)

args <- commandArgs(TRUE) 
#setwd("D:/Users/flyku/Documents/IRIS3-data/test_dzscore")
#setwd("/var/www/html/iris3/data/20190802103754")
#srcDir <- getwd()
#gene_symbol <-"CA8" 
#jobid <- "20190802103754"
srcDir <- args[1]
gene_symbol <- args[2]
jobid <- args[3]

Plot.GeneTSNE<-function(gene.name=NULL){
  tmp.gene.expression<- my.object@data
  tmp.dim<-as.data.frame(my.object@dr$tsne@cell.embeddings)
  tmp.MatchIndex<- match(my.object@cell.names,rownames(tmp.dim))
  tmp.dim<-tmp.dim[tmp.MatchIndex,]
  tmp.gene.name<-paste0("^",gene.name,"$")
  tmp.One.gene.value<-tmp.gene.expression[grep(tmp.gene.name,rownames(tmp.gene.expression)),]
  tmp.dim.df<-cbind.data.frame(tmp.dim,Gene=tmp.One.gene.value)
  g<-ggplot(tmp.dim.df,aes(x=tSNE_1,y=tSNE_2,color=Gene))
  g<-g+geom_point()+scale_color_gradient(low="grey",high = "red")
  g<-g+theme_bw()+labs(color=paste0(gene.name,"\nexpression\nvalue"))
  g
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
my.object <- readRDS("seurat_obj.rds")

png(paste("regulon_id/",gene_symbol,".tsne.png",sep = ""),width=700, height=700)
if (!file.exists(paste("regulon_id/",gene_symbol,".tsne.png",sep = ""))){
  Plot.GeneTSNE(gene_symbol)
}
quiet(dev.off())


