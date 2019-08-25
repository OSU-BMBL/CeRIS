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
if(!require(LTMGSCA)){
  devtools::install_github("zy26/LTMGSCA")
}
#pre-optional
options(stringsAsFactors = F)
options(check.names = F)
reset_par <- function(){
  op <- structure(list(xlog = FALSE, ylog = FALSE, adj = 0.5, ann = TRUE,
                       ask = FALSE, bg = "transparent", bty = "o", cex = 1, cex.axis = 1,
                       cex.lab = 1, cex.main = 1.2, cex.sub = 1, col = "black",
                       col.axis = "black", col.lab = "black", col.main = "black",
                       col.sub = "black", crt = 0, err = 0L, family = "", fg = "black",
                       fig = c(0, 1, 0, 1), fin = c(6.99999895833333, 6.99999895833333
                       ), font = 1L, font.axis = 1L, font.lab = 1L, font.main = 2L,
                       font.sub = 1L, lab = c(5L, 5L, 7L), las = 0L, lend = "round",
                       lheight = 1, ljoin = "round", lmitre = 10, lty = "solid",
                       lwd = 1, mai = c(1.02, 0.82, 0.82, 0.42), mar = c(5.1, 4.1,
                                                                         4.1, 2.1), mex = 1, mfcol = c(1L, 1L), mfg = c(1L, 1L, 1L,
                                                                                                                        1L), mfrow = c(1L, 1L), mgp = c(3, 1, 0), mkh = 0.001, new = FALSE,
                       oma = c(0, 0, 0, 0), omd = c(0, 1, 0, 1), omi = c(0, 0, 0,
                                                                         0), pch = 1L, pin = c(5.75999895833333, 5.15999895833333),
                       plt = c(0.117142874574832, 0.939999991071427, 0.145714307397962,
                               0.882857125425167), ps = 12L, pty = "m", smo = 1, srt = 0,
                       tck = NA_real_, tcl = -0.5, usr = c(0.568, 1.432, 0.568,
                                                           1.432), xaxp = c(0.6, 1.4, 4), xaxs = "r", xaxt = "s", xpd = FALSE,
                       yaxp = c(0.6, 1.4, 4), yaxs = "r", yaxt = "s", ylbias = 0.2), .Names = c("xlog",
                                                                                                "ylog", "adj", "ann", "ask", "bg", "bty", "cex", "cex.axis",
                                                                                                "cex.lab", "cex.main", "cex.sub", "col", "col.axis", "col.lab",
                                                                                                "col.main", "col.sub", "crt", "err", "family", "fg", "fig", "fin",
                                                                                                "font", "font.axis", "font.lab", "font.main", "font.sub", "lab",
                                                                                                "las", "lend", "lheight", "ljoin", "lmitre", "lty", "lwd", "mai",
                                                                                                "mar", "mex", "mfcol", "mfg", "mfrow", "mgp", "mkh", "new", "oma",
                                                                                                "omd", "omi", "pch", "pin", "plt", "ps", "pty", "smo", "srt",
                                                                                                "tck", "tcl", "usr", "xaxp", "xaxs", "xaxt", "xpd", "yaxp", "yaxs",
                                                                                                "yaxt", "ylbias"))
  par(op)
}
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
Data.Preprocessing<-function(TenX = FALSE) {
  if(TenX== TRUE){
    my.object[["percent.mt"]] <- PercentageFeatureSet(my.object, pattern = "^MT-")
    my.object <- (subset(my.object, subset = nFeature_RNA > 200 & nFeature_RNA < 3000 & percent.mt < 5))
  }
  return(my.object)
}

Get.CellType<-function(cell.type=1,...){
  if(!is.null(cell.type)){
    my.cell.regulon.filelist<-list.files(pattern = "bic.regulon_gene_symbol.txt")
    my.cell.regulon.indicator<-grep(paste0("_",as.character(cell.type),"_bic"),my.cell.regulon.filelist)
    my.cts.regulon.raw<-readLines(my.cell.regulon.filelist[my.cell.regulon.indicator])
    my.regulon.list<-strsplit(my.cts.regulon.raw,"\t")
    return(my.regulon.list)
  }else{stop("please input a cell type")}
  
}
Generate.Regulon<-function(cell.type=NULL,regulon=1,...){
  x<-Get.CellType(cell.type = cell.type)
  my.rowname<-rownames(my.object)
  gene.index<-sapply(x[[regulon]][-1],function(x) grep(paste0("^",x,"$"),my.rowname))
  # my.object@data stores normalized data
  tmp.regulon<-my.object@assays$RNA@data[gene.index,]
  return(tmp.regulon)
}
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
Get.MarkerGene<-function(customized=T){
  if(customized==T){
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
Dim.Calculate<-function(Matrix.type="GEM",...){
  if(Matrix.type == "GEM"){
    dm<-DiffusionMap(t(as.matrix(GetAssayData(object = my.object,assay = "RNA",slot = "data"))))
    rd2 <- cbind(DC1 = dm$DC1, DC2 = dm$DC2)
    a <- SimpleList( DiffMap = rd2)
    print("using GEM.")
  } 
  # second mode Regulon score
  if(Matrix.type == "RSM") { 
    dm<-DiffusionMap(t(as.matrix(my.regulon.cell.Matrix)))
    rd2 <- cbind(DC1 = dm$DC1, DC2 = dm$DC2)
    a<-SimpleList( DiffMap = rd2)
    print("using Regulon score matrix") 
  }
  return(a)
}
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
  par(mar=c(3.1, 3.1, 2.1, 5.1), xpd=TRUE)
  plot(reducedDims(tmp.trajectory.cluster)$DiffMap,
       col=alpha(my.classification.color[as.factor(tmp.trajectory.cluster$cell.label)],0.7),
       pch=20,frame.plot = FALSE,
       asp=1)
  #grid()
  tmp.color.cat<-cbind.data.frame(CellName=as.character(tmp.trajectory.cluster$cell.label),
                                  Color=my.classification.color[as.factor(tmp.trajectory.cluster$cell.label)])
  tmp.color.cat<-tmp.color.cat[!duplicated(tmp.color.cat$CellName),]
  tmp.color.cat<-tmp.color.cat[order(as.numeric(tmp.color.cat$CellName)),]
  # add legend
  if(length(tmp.color.cat$CellName)>10){
    legend("topright",legend = tmp.color.cat$CellName,
           inset=c(0.1,0), ncol=2,
           col = tmp.color.cat$Color,pch = 20,
           cex=0.8,title="cluster",bty='n')
  } else {legend("topright",legend = tmp.color.cat$CellName,
                 inset=c(0.1,0), ncol=1,
                 col = tmp.color.cat$Color,pch = 20,
                 cex=0.8,title="cluster",bty='n')}
  
  
  if(add.line==T){
    lines(SlingshotDataSet(tmp.trajectory.cluster), 
          lwd=1,pch=3, col=alpha('black',0.7),
          type="l",show.constraints=show.constraints)
  }
  reset_par()
}
Plot.Regulon.Trajectory<-function(customized=T,cell.type=1,regulon=1,start.cluster=NULL,end.cluster=NULL,...){
  tmp.trajectory.cluster<-Get.cluster.Trajectory(customized = customized,start.cluster=start.cluster,end.cluster=end.cluster)
  tmp.regulon.score<- Get.RegulonScore(cell.type = cell.type,regulon = regulon)
  tmp.cell.name<-colnames(tmp.trajectory.cluster)
  tmp.cell.name.index<-match(tmp.cell.name,rownames(tmp.regulon.score))
  tmp.regulon.score<-tmp.regulon.score[tmp.cell.name.index,]
  val<-tmp.regulon.score$regulon.score
  #
  
  layout(matrix(1:2,nrow=1),widths=c(0.7,0.3))
  grPal <- colorRampPalette(c("blue","red"))
  tmp.color<-grPal(10)[as.numeric(cut(val,breaks=10))]
  
  par(mar=c(5.1,2.1,1.1,2.1))
  plot(reducedDims(tmp.trajectory.cluster)$DiffMap,
       col=alpha(tmp.color,0.7),
       pch=20,frame.plot = FALSE,
       asp=1)
  lines(SlingshotDataSet(tmp.trajectory.cluster))
  #grid()
  xl <- 1
  yb <- 1
  xr <- 1.5
  yt <- 2
  
  par(mar=c(20.1,1.1,1.1,3.1))
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
  mtext("Relugon Score", cex=1,side=1)
  mtext(c(tmp.min,tmp.Nmean,0,tmp.Pmean,tmp.max),
        at=c(tmp.cor[5],tmp.cor[15],tmp.cor[25],tmp.cor[35],tmp.cor[45]),
        side=2,las=1,cex=0.7)
  wreset_par()
  
}