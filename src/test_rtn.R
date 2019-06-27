library(RTN)
library(RTNsurvival)
library(scales)
library(viper)
library(Fletcher2013b)

data("rtni1st")
#colAnnotation <- tni.get(rtni1st, what="colAnnotation")
#head(colAnnotation)
risk.tfs <- c("AFF3", "AR", "ARNT2", "BRD8", "CBFB", "CEBPB", "E2F2", "E2F3", "ENO1",
              "ESR1", "FOSL1", "FOXA1", "GATA3", "GATAD2A", "LZTFL1", "MTA2", "MYB",
              "MZF1", "NFIB", "PPARD", "RARA", "RB1", "RUNX3", "SNAPC2", "SOX10",
              "SPDEF", "TBX19", "TCEAL1", "TRIM29", "XBP1", "YBX1", "YPEL3", "ZNF24",
              "ZNF434", "ZNF552", "ZNF587")
tns1st <- tni2tnsPreprocess(tni = rtni1st, regulatoryElements = risk.tfs,
                            time = "time", event = "event", endpoint = 120,
                            keycovar = c("Age","Grade"))
#tnsPlotGSEA2(tns1st, "MB-5365", regs = "ESR1")
#tns1st <- tnsGSEA2(tns1st)
#
#regact_gsea <- tnsGet(tns1st, "regulonActivity")$dif
#sdata <- tnsGet(tns1st, "survivalData")
#attribs <- c("ER+", "ER-","LumA","LumB","Basal","Her2","Normal")
#pheatmap(t(regact_gsea), annotation_col = sdata[,attribs], show_colnames = FALSE,
#         annotation_legend = FALSE, clustering_method = "ward.D2",
#         clustering_distance_rows = "correlation",
#         clustering_distance_cols = "correlation")
tns1st_area <- tnsAREA3(tns1st)
regact_area <- tnsGet(tns1st_area, "regulonActivity")$dif
r_gsea <- apply(regact_gsea, 2, rank)
r_area <- apply(regact_area, 2, rank)
plot(r_gsea[,"ESR1"], r_area[,"ESR1"])
tns1st_area <- tnsKM(tns1st_area)
tnsPlotKM(tns1st_area, regs = "ESR1", attribs = attribs, panelWidths=c(3,1,4), width = 6)


data(dt4rtn)

# select 5 regulatoryElements for a quick demonstration!
tfs4test <- dt4rtn$tfs[c("PTTG1","E2F2","FOXM1","E2F3","RUNX2")]

## Not run: 

rtni <- tni.constructor(expData=dt4rtn$gexp, regulatoryElements=tfs4test, 
                        rowAnnotation=dt4rtn$gexpIDs)
rtni <- tni.permutation(rtni)
rtni <- tni.bootstrap(rtni)
rtni <- tni.dpi.filter(rtni)
genes <- c("APLP2","ATP6V1C2","DHCR7","GSPT1","HDGF","HMGA1","SF1")
itni <- tni.constructor(expData=exp_data, regulatoryElements=genes)
itni <- tni.permutation(itni)
#rtni <- tni.bootstrap(rtni)
itni <- tni.dpi.filter(itni)
#run aREA algorithm
EScores <- tni.area3(itni)
plot(EScores$dif)

sc <- apply(EScores$dif, 2, rescale, to=c(-1.8, 1.8))
sc <- as.data.frame(sc)
sc2 <- colMeans(sc)
sc2 <- apply(sc, 1, mean)

barplot(sc2)

###
BiocManager::install("RTN")
library(RTN)
wd <- "d:/Users/flyku/Documents/IRIS3-data/test_dzscore"
setwd(wd)
exp_data<- read.delim(paste(jobid,"_filtered_expression.txt",sep = ""),check.names = FALSE, header=TRUE,row.names = 1)
exp_data <- as.matrix(exp_data)

label_data <- read.table(paste(jobid,"_cell_label.txt",sep = ""),sep="\t",header = T)

data(dt4rtn)
# select 5 regulatoryElements for a quick demonstration!
tfs4test <- dt4rtn$tfs[c("PTTG1","E2F2","FOXM1","E2F3","RUNX2")]
## Not run:
rtni <- tni.constructor(expData=dt4rtn$gexp, regulatoryElements=tfs4test,
                        rowAnnotation=dt4rtn$gexpIDs)
rtni <- tni.permutation(rtni)
rtni <- tni.bootstrap(rtni)
rtni <- tni.dpi.filter(rtni)
#run aREA algorithm
EScores <- tni.area3(rtni)

object <- tni.constructor(expData=exp_data, regulatoryElements=genes)
object <- tni.permutation(object)
#rtni <- tni.bootstrap(rtni)
object <- tni.dpi.filter(object)
tf <-tfs4test
genes <- c("ANAPC11","APLP2","ATP6V1C2","DHCR7","GSPT1","HDGF","HMGA1")
rown=as.data.frame(rownames(exp))


setMethod(
  "tni.area3",
  "TNI",function(object, minRegulonSize=1, doSizeFilter=FALSE, scale=FALSE, 
                 tnet="dpi", tfs=NULL, samples=NULL, features=NULL, refsamp=NULL, 
                 log=FALSE, verbose=TRUE){
    if(object@status["Preprocess"]!="[x]")stop("NOTE: TNI object is not compleate: requires preprocessing!")
    if(object@status["Permutation"]!="[x]")stop("NOTE: TNI object is not compleate: requires permutation/bootstrap and DPI filter!")  
    if(object@status["DPI.filter"]!="[x]")stop("NOTE: TNI object is not compleate: requires DPI filter!")
    
    #---check compatibility
    object <- upgradeTNI(object)
    
    ##-----check and assign parameters
    tnai.checks(name="minRegulonSize",para=minRegulonSize)
    tnai.checks(name="doSizeFilter",para=doSizeFilter)
    tnai.checks(name="scale",para=scale)
    tnai.checks(name="area.tnet",para=tnet)
    tnai.checks(name="tfs",para=tfs)
    tnai.checks(name="samples",para=samples)
    tnai.checks(name="features",para=features)
    tnai.checks(name="refsamp",para=refsamp)
    tnai.checks(name="log",para=log) 
    tnai.checks(name="verbose",para=verbose) 
    object@para$area3 <- list(minRegulonSize=minRegulonSize, 
                              doSizeFilter=doSizeFilter,
                              scale=scale, tnet=tnet, log=log)
    
    ##------ compute reference gx vec
    if(scale) object@gexp <- t(scale(t(object@gexp)))
    if(is.null(refsamp)){
      gxref <- apply(object@gexp,1,mean)
    } else {
      idx <- refsamp %in% colnames(object@gexp)
      if(!all(idx)){
        stop("NOTE: 'refsamp' should list only valid names!")
      }
      gxref <- apply(object@gexp[,refsamp],1,mean)
    }
    ##----- set samples
    if(!is.null(samples)){
      idx <- samples %in% colnames(object@gexp)
      if(!all(idx)){
        stop("NOTE: 'samples' should list only valid names!")
      }
      samples<-colnames(object@gexp)[colnames(object@gexp) %in% samples]
    } else {
      samples<-colnames(object@gexp)
    }
    ##----- set features
    if(!is.null(features)){
      col1<-sapply(1:ncol(object@rowAnnotation),function(i){
        sum(features%in%object@rowAnnotation[,i],na.rm=TRUE)
      })
      col1<-which(col1==max(col1))[1]
      idx<-object@rowAnnotation[[col1]]%in%features
      object@results$tn.ref[!idx,] <- 0
      object@results$tn.dpi[!idx,] <- 0
    }
    
    ##-----get regulons
    if(tnet=="ref"){
      listOfRegulonsAndMode <- tni.get(object,what="refregulons.and.mode")
    } else {
      listOfRegulonsAndMode <- tni.get(object,what="regulons.and.mode")
    }
    
    ##-----set regs
    if(!is.null(tfs)){
      if(sum(tfs%in%object@regulatoryElements) > sum(tfs%in%names(object@regulatoryElements) ) ){
        tfs <- object@regulatoryElements[object@regulatoryElements%in%tfs]
      } else {
        tfs <- object@regulatoryElements[names(object@regulatoryElements)%in%tfs]
      }
      if(length(tfs)==0)stop("NOTE: 'tfs' argument has no valid names!")
    } else {
      tfs<-object@regulatoryElements
    }
    listOfRegulonsAndMode <- listOfRegulonsAndMode[tfs]
    
    ##-----remove partial regs, below the minRegulonSize
    for(nm in names(listOfRegulonsAndMode)){
      reg<-listOfRegulonsAndMode[[nm]]
      if(sum(reg<0)<minRegulonSize){
        reg<-reg[reg>0]
      }
      if(sum(reg>0)<minRegulonSize){
        reg<-reg[reg<0]
      }
      listOfRegulonsAndMode[[nm]]<-reg
    }
    
    ##-----check regulon size (both clouds)
    gs.size.max <- unlist(lapply(listOfRegulonsAndMode, function(reg){
      max(sum(reg>0),sum(reg<0))
    }))
    gs.size.min <- unlist(lapply(listOfRegulonsAndMode, function(reg){
      min(sum(reg>0),sum(reg<0))
    }))
    ##-----stop when no subset passes the size requirement
    if(all(gs.size.max<minRegulonSize)){
      stop(paste("NOTE: no partial regulon has minimum >= ", minRegulonSize, sep=""))
    }
    ##-----get filtered list
    if(doSizeFilter){
      listOfRegulonsAndMode <- listOfRegulonsAndMode[which(gs.size.min>=minRegulonSize)]
      tfs<-tfs[tfs%in%names(listOfRegulonsAndMode)]
      if(length(listOfRegulonsAndMode)==0){
        stop("NOTE: no regulon has passed the 'doSizeFilter' requirement!")
      }
    } else {
      listOfRegulonsAndMode <- listOfRegulonsAndMode[which(gs.size.max>=minRegulonSize)]
      tfs<-tfs[tfs%in%names(listOfRegulonsAndMode)]
      if(length(listOfRegulonsAndMode)==0){
        stop("NOTE: no regulon has passed the 'minRegulonSize' requirement!")
      }
    }
    
    #--- get phenotypes
    if(log){
      phenotypes <- log2(1+object@gexp)-log2(1+gxref)
    } else {
      phenotypes <- object@gexp-gxref
    }
    
    #--- get regulons evaluated by EM algorithm
    if (verbose) {
      cat("Running EM algorithm... ")
    }
    if(tnet=="ref"){
      listOfRegulonsAndModeGmm <- tni.get(object,what="refregulons.and.mode.gmm")
    } else {
      listOfRegulonsAndModeGmm <- tni.get(object,what="regulons.and.mode.gmm")
    }
    listOfRegulonsAndModeGmm <- listOfRegulonsAndModeGmm[tfs]
    
    #--- set regulons for aREA
    arearegs <- list()
    for(tf in tfs[1]){
      arearegs[[tf]]$tfmode <- listOfRegulonsAndModeGmm[[tf]]$gmm
      arearegs[[tf]]$likelihood <- listOfRegulonsAndModeGmm[[tf]]$mi
    }
    if (verbose) {
      cat("Running aREA algorithm...\n")
    }
    
    cors <- cor(t(exp_data[rownames(exp_data) %in% genes,]),method = "spearman")
    nes <- t(aREA(eset=phenotypes, regulon=arearegs, minsize=0, verbose=FALSE)$nes)
    nes <- nes[samples,tfs]
    colnames(nes) <- names(tfs)
    
    #-- for compatibility, wrap up results into the same format
    regulonActivity <- list(dif=nes)
    regulonActivity <- .tni.stratification.area(regulonActivity)
    return(regulonActivity)
  }
)

