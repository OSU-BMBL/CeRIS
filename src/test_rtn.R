library(RTN)
library(RTNsurvival)
library(scales)

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
