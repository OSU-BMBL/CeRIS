
########## Sort regulon by regulon specificity score ##################
# used files:
# filtered exp matrix
# cell label
# regulon_gene_symbol, regulon_gene_id, regulon_motif, motif_ranks (from merge_bbc.R)

library(scales)
library(sgof)

args <- commandArgs(TRUE)
wd <- args[1] # filtered expression file name
jobid <- args[2] # user job id
# wd<-getwd()
####test
# wd <- "D:/Users/flyku/Documents/IRIS3-data/20190823145911"
# setwd("C:/Users/wan268/Documents/iris3_data/20190818190915")
# jobid <-20190818190915 
# expFile <- "20190818190915_filtered_expression.txt"
# labelFile <- "20190818190915_cell_label.txt"
# wd <- getwd()
#setwd(wd)

quiet <- function(x) { 
  sink(tempfile()) 
  on.exit(sink()) 
  invisible(force(x)) 
} 


# calculate Jensen-Shannon Divergence (JSD), used to calculate regulon specificity score (RSS)
calc_jsd <- function(v1,v2) {
  H <- function(v) {
    v <- v[v > 0]
    return(sum(-1 * v * log(v)))
  }
  return (H(v1/2+v2/2) - (H(v1)+H(v2))/2)
}


#num_ct <- 1
#genes <- c("ANAPC11","APLP2","ATP6V1C2","DHCR7","GSPT1","HDGF","HMGA1")
#calculate regulon activity score (RAS) 
#expr <- exp_data
# genes <- total_gene_list
calc_ras <- function(expr=NULL, genes,method=c("aucell","zscore","plage","ssgsea","custom_auc")) {
  if (method=="aucell"){ #use top 10% cutoff
    require(AUCell)
    names(genes) <- 1:length(genes)
    cells_rankings <- AUCell_buildRankings(expr,plotStats = F) 
    cells_AUC <- AUCell_calcAUC(genes, cells_rankings, aucMaxRank=nrow(cells_rankings)*0.1)
    #score_vec <- cells_AUC@assays@data@listData[['AUC']]
    score_vec <- cells_AUC@assays@.xData$data$AUC

  } else if (method=="zscore"){
    require("GSVA")
    score_vec <- gsva(expr,gset=genes,method="zscore")
  } else if (method=="plage"){
    require("GSVA")
    score_vec <- gsva(expr,gset=genes,method="plage")
  } else if (method=="ssgsea"){
    require("GSVA")
    score_vec <- gsva(expr,gset=genes,method="ssgsea")
  } else if (method=="gsva"){
    require("GSVA")
    require("snow")
    score_vec <- gsva(expr,gset=genes,method="gsva",kcdf="Gaussian",abs.ranking=F,verbose=T,parallel.sz=8)
  } else if (method=="rank_u_test"){
    require(AUCell)
    require(BioQC)
    if(!data.table::is.data.table(expr))
    expr <- data.table::data.table(expr, keep.rownames=TRUE)
    data.table::setkey(expr, "rn") # (reorders rows)
    colsNam <- colnames(expr)[-1] # 1=row names
    names(genes) <- 1:length(genes)
    dim(exp_data)
    rankings <- expr[, (colsNam):=lapply(-.SD, data.table::frank, ties.method="random", na.last="keep"),
                         .SDcols=colsNam]
    rn <- rankings$rn
    rankings <- as.matrix(rankings[,-1])
    rownames(rankings) <- rn
    indx <- seq_len(nrow(label_data))
    #geneset=genes[[1]]
    #genes <- genes[1:20]
    score_vec <- sapply(genes,function(geneset){
      #geneset <- unique(geneset)
      #geneset <- geneset[which(geneset %in% rownames(rankings))]
      #'%notin%' <- Negate('%in%')
      #gSetRanks <- rankings[which(rownames(rankings) %in% geneset),,drop=FALSE]
      #other_ranking <- rankings[which(rownames(rankings) %notin% geneset),,drop=FALSE]
      #wilcox.test(gSetRanks[,1], other_ranking[,1])$p.value
      #pval <- sapply(indx, function(i) wilcox.test(gSetRanks@assays@.xData$data$ranking[,i], other_ranking@assays@.xData$data$ranking[,i])$p.value)
      set_in_list <- rownames(rankings) %in% geneset
      #pval <- sapply(indx, function(i) wmwTest(rankings[,i], set_in_list, valType="p.two.sided"))
      pval <- wmwTest(rankings, set_in_list, valType="p.two.sided", simplify = T)
      pval_correction <- sgof::BH(pval)
      adj_pval <-pval_correction$Adjusted.pvalues[order(match(pval_correction$data,pval))]
      print(Sys.time())
      return(-1*log10(adj_pval))
    })
    score_vec <- t(score_vec)
    colnames(score_vec) <- label_data[,1]
    
    ##### test two u-test function speed
    #library(microbenchmark)
    #microbenchmark(
    #  sapply(indx, function(i) wmwTest(rankings[,i], set_in_list, valType="p.two.sided")),times = 10
    #)
    #microbenchmark(
    #  sapply(indx, function(i) wilcox.test(gSetRanks[,i], other_ranking[,i])$p.value),times = 10
    #)
    
    #
  }
  return(score_vec)
}

#normalization
normalize_ras <- function(score_vec){
  #normalize score_vec(regulon activity score) to range(0,1) and sum=1
  score_vec <- apply(score_vec, 1, rescale)
  score_vec <- t(score_vec)
  score_vec <- as.data.frame(t(apply(data.frame(score_vec), 1, function(x){
    x <- x/sum(x)
  })))
  return(score_vec)
}

# test if difference in ras among two groups (whether in this cell type), FDR=0.05(default) used by Benjamini-Hochberg procedure
#score_vec <- ras
calc_ras_pval <- function(label_data=NULL,score_vec=NULL, num_ct=1){
  # get cell type vector, add 1 if in this cell type
  ct_vec <- ifelse(label_data[,2] %in% num_ct, 1, 0)
  group1 <- score_vec[,which(ct_vec==1)]
  group0 <- score_vec[,which(ct_vec==0)]
  
  ## two sample t-test
  #pval <- apply(data.frame(1:nrow(group1)),1, function(x){
  #  return (t.test(group1[x,],group0[x,])$p.value)
  #})
  
  ## wilcox rank sum test
  pval <- apply(data.frame(1:nrow(group1)),1, function(x){
    return (wilcox.test(as.numeric(group1[x,]),as.numeric(group0[x,]))$p.value)
  })
  ##Benjamini-Hochberg procedure
  pval_correction <- sgof::BH(pval)
  adj_pval <-pval_correction$Adjusted.pvalues[order(match(pval_correction$data,pval))]
  return(adj_pval)
  
  ## plots for test 
  #new_regulon_filter_by_fdr <- !which(adj_pval>0.05) %in% which(pval>0.05)
  #if (isTRUE(any(new_regulon_filter_by_fdr))){
  #  s1<-score_vec[which(result_pvalue>0.05)[!which(result_pvalue>0.05) %in% which(r1>0.05)],]
  #  for (i in 1:16) {
  #    barplot(as.matrix(s1[i,]))
  #  }
  #} else {
  #  pval_order <- order(adj_pval)
  #  
  #  s2 <- score_vec[pval_order,]
  #  for (i in 1:16) {
  #    barplot(as.matrix(s2[i,]))
  #  }
  #}
}
#score_vec=ras
# calculate regulon specificity score (RSS), based on regulon activity score and cell type specific infor,
calc_rss <- function (label_data=NULL,score_vec=NULL, num_ct=1){
  
  # get cell type vector, add 1 if in this cell type
  ct_vec <- ifelse(label_data[,2] %in% num_ct, 1, 0)

  # also normalize ct_vec to sum=1
  sum_ct_vec <- sum(ct_vec)
  ct_vec <- ct_vec/sum_ct_vec
  jsd_result <- apply(as.data.frame(score_vec), 1, function(x){
    return (calc_jsd(x,ct_vec))
  })
  #calculate regulon specificity score (RSS); which defined by converting JSD to a similarity score
  rss <- 1- sqrt(jsd_result)
  return(rss)
}


sort_dir <- function(dir) {
  tmp <- sort(dir)
  split <- strsplit(tmp, "_CT_") 
  split <- as.numeric(sapply(split, function(x) x <- sub("_bic.*", "", x[2])))
  return(tmp[order(split)])
  
}

alldir <- list.dirs(path = wd)
alldir <- grep("*_bic$",alldir,value=T)
alldir <- sort_dir(alldir)

exp_data<- read.delim(paste(jobid,"_filtered_expression.txt",sep = ""),check.names = FALSE, header=TRUE,row.names = 1)
exp_data <- as.matrix(exp_data)

label_data <- read.table(paste(jobid,"_cell_label.txt",sep = ""),sep="\t",header = T)
marker_data <- read.table("cell_type_unique_marker.txt",sep="\t",header = T)
total_motif_list <- vector()
total_gene_list <- vector()
total_gene_index <- 1
#i=1
## to speed up gsva process, read all genes  to one list
for (i in 1:length(alldir)) {
  regulon_gene_name_handle <- file(paste(jobid,"_CT_",i,"_bic.regulon_gene_symbol.txt",sep = ""),"r")
  regulon_gene_name <- readLines(regulon_gene_name_handle)
  close(regulon_gene_name_handle)
  total_gene_list <- append(total_gene_list,regulon_gene_name)
} 
print(Sys.time())
total_gene_list <- lapply(strsplit(total_gene_list,"\\t"), function(x){x[-1]})
#total_gene_list <- total_gene_list[1:10]
if (ncol(exp_data) > 5000) {
  total_ras <- calc_ras(expr = exp_data,genes=total_gene_list,method = "rank_u_test")
} else {
  total_ras <- calc_ras(expr = exp_data,genes=total_gene_list,method = "rank_u_test")
}

#i=1
# genes=x= gene_name_list[[1]]
for (i in 1:length(alldir)) {
  
  regulon_gene_name_handle <- file(paste(jobid,"_CT_",i,"_bic.regulon_gene_symbol.txt",sep = ""),"r")
  regulon_gene_name <- readLines(regulon_gene_name_handle)
  close(regulon_gene_name_handle)
  
  regulon_gene_id_handle <- file(paste(jobid,"_CT_",i,"_bic.regulon_gene_id.txt",sep = ""),"r")
  regulon_gene_id <- readLines(regulon_gene_id_handle)
  close(regulon_gene_id_handle)
  
  regulon_motif_handle <- file(paste(jobid,"_CT_",i,"_bic.regulon_motif.txt",sep = ""),"r")
  regulon_motif <- readLines(regulon_motif_handle)
  close(regulon_motif_handle)
  
  
  motif_rank <- read.table(paste(jobid,"_CT_",i,"_bic.motif_rank.txt",sep = ""))
  
  gene_name_list <- lapply(strsplit(regulon_gene_name,"\\t"), function(x){x[-1]})
  gene_id_list <- lapply(strsplit(regulon_gene_id,"\\t"), function(x){x[-1]})
  motif_list <- lapply(strsplit(regulon_motif,"\\t"), function(x){x[-1]})
  
  ras <- total_ras[total_gene_index:(total_gene_index + length(gene_name_list) - 1),]
  total_gene_index <- total_gene_index + length(gene_name_list) 
  originak_ras <- ras
  ras <- normalize_ras(ras)
  ##adj_pval <- calc_ras_pval(label_data=label_data,score_vec = ras,num_ct = i)
  ## remove regulons adjust pval >= 0.05
  ## disabled
  ##rss_keep_index <- which(adj_pval < 0.05)
  ##if (length(rss_keep_index) > 100000000) {
  ##  ras <- ras[rss_keep_index,]
  ##  originak_ras <- originak_ras[rss_keep_index,]
  ##  gene_name_list <- gene_name_list[rss_keep_index]
  ##  gene_id_list <- gene_id_list[rss_keep_index]
  ##  motif_list <- motif_list[rss_keep_index]
  ##}
  rss_list <- calc_rss(label_data=label_data,score_vec = ras,num_ct = i)
  rss_list <- as.list(rss_list)
  # calculate to be removed regulons index, if no auc score or less than 0.05
  rss_keep_index <- lapply(rss_list, function(x){
    if(is.na(x))
      return (1)
    else return(0)
  })
  rss_keep_index <- which(unlist(rss_keep_index) == 0)
  rss_list <- rss_list[rss_keep_index]
  gene_name_list <- gene_name_list[rss_keep_index]
  gene_id_list <- gene_id_list[rss_keep_index]
  motif_list <- motif_list[rss_keep_index]
  ras <- ras[rss_keep_index,]
  originak_ras <- originak_ras[rss_keep_index,]

  rss_rank <- order(unlist(rss_list),decreasing = T)
  # x <- gene_name_list[[1]]
  gene_name_list <- gene_name_list[rss_rank]
  gene_id_list <- gene_id_list[rss_rank]
  motif_list <- motif_list[rss_rank]
  ras <- ras[rss_rank,]
  originak_ras <- originak_ras[rss_rank,]
  rss_list <- rss_list[rss_rank]
  
  
  marker<-lapply(gene_name_list, function(x){
    x[which(x%in%marker_data[,i])]
  })
  
  if(sum(sapply(marker, length))>0){
    rss_rank<-order(sapply(marker,length),decreasing=T)
    marker <- marker[rss_rank]
    rss_list <- rss_list[rss_rank]
    gene_name_list <- gene_name_list[rss_rank]
    gene_id_list <- gene_id_list[rss_rank]
    # put marker genes on top
    gene_id_list <- mapply(function(X,Y,Z){
      id <- which(Y %in% X)
      return(unique(append(Z[id],Z)))
    },X=marker,Y=gene_name_list,Z=gene_id_list)
    
    gene_name_list <- mapply(function(X,Y){
      return(unique(append(X,Y)))
    },X=marker,Y=gene_name_list)
    
    motif_list <- motif_list[rss_rank]
    ras <- ras[rss_rank,]
    originak_ras <- originak_ras[rss_rank,]
  }

  
 
  colnames(ras) <- label_data[,1]
  colnames(originak_ras) <- label_data[,1]
  
  write.table(as.data.frame(originak_ras),paste(jobid,"_CT_",i,"_bic.regulon_activity_score.txt",sep = ""),sep = "\t",col.names = T,row.names = T,quote = F)
  total_motif_list <- append(total_motif_list,unlist(motif_list))
  #j=1
  for (j in 1:length(gene_name_list)) {
    regulon_tag <- paste("CT",i,"S-R",j,sep = "")
    gene_name_list[[j]] <- append(regulon_tag,gene_name_list[[j]])
    gene_id_list[[j]] <- append(regulon_tag,gene_id_list[[j]])
    motif_list[[j]] <- append(regulon_tag,motif_list[[j]])
    #rss_list[[j]] <- append(regulon_tag,rss_list[[j]])
    rss_list[[j]] <- append(rss_list[[j]],marker[[j]])
  }
  options(stringsAsFactors=FALSE)
  regulon_rank_result <- data.frame()
  for (j in 1:length(gene_name_list)) {
    regulon_tag <- paste("CT",i,"S-R",j,sep = "")
    this_motif_value <- motif_rank[which(motif_rank[,1] == motif_list[[j]][2]),-1]
    this_motif_value <- cbind(regulon_tag,this_motif_value)
    regulon_rank_result <- rbind(regulon_rank_result,this_motif_value)
  }

  #write.table(regulon_rank_result,paste(jobid,"_CT_",i,"_bic.regulon_rank.txt",sep = ""),sep = "\t",col.names = F,row.names = F,quote = F)
  cat("",file=paste(jobid,"_CT_",i,"_bic.regulon_gene_symbol.txt",sep = ""))
  cat("",file=paste(jobid,"_CT_",i,"_bic.regulon_gene_id.txt",sep = ""))
  cat("",file=paste(jobid,"_CT_",i,"_bic.regulon_motif.txt",sep = ""))
  cat("",file=paste(jobid,"_CT_",i,"_bic.regulon_rank.txt",sep = ""))
  for (j in 1:length(gene_name_list)) {
    cat(gene_name_list[[j]],file=paste(jobid,"_CT_",i,"_bic.regulon_gene_symbol.txt",sep = ""),append = T,sep = "\t")
    cat("\n",file=paste(jobid,"_CT_",i,"_bic.regulon_gene_symbol.txt",sep = ""),append = T)
    
    cat(gene_id_list[[j]],file=paste(jobid,"_CT_",i,"_bic.regulon_gene_id.txt",sep = ""),append = T,sep = "\t")
    cat("\n",file=paste(jobid,"_CT_",i,"_bic.regulon_gene_id.txt",sep = ""),append = T)
    
    cat(motif_list[[j]],file=paste(jobid,"_CT_",i,"_bic.regulon_motif.txt",sep = ""),append = T,sep = "\t")
    cat("\n",file=paste(jobid,"_CT_",i,"_bic.regulon_motif.txt",sep = ""),append = T)
    
    cat(as.character(regulon_rank_result[j,]),file=paste(jobid,"_CT_",i,"_bic.regulon_rank.txt",sep = ""),append = T,sep = "\t")
    cat("\t",file=paste(jobid,"_CT_",i,"_bic.regulon_rank.txt",sep = ""),append = T)
    cat(rss_list[[j]],file=paste(jobid,"_CT_",i,"_bic.regulon_rank.txt",sep = ""),append = T,sep = "\t")
    cat("\n",file=paste(jobid,"_CT_",i,"_bic.regulon_rank.txt",sep = ""),append = T)
  }
}
tmp_list <- strsplit(total_motif_list,",")
tmp_list <- lapply(tmp_list, function(x){
  paste("ct",x[1],"bic",x[2],"m",x[3],sep = "")
})

write.table(unlist(tmp_list),"total_motif_list.txt",quote = F,row.names = F,col.names = F)

##.AUC.geneSet_norm <- function(geneSet=genes, rankings=cells_rankings, aucMaxRank=nrow(cells_rankings)*0.05, gSetName="")
##{
##  geneSet <- unique(geneSet)
##  nGenes <- length(geneSet)
##  geneSet <- geneSet[which(geneSet %in% rownames(rankings))]
##  missing <- nGenes-length(geneSet)
##  '%notin%' <- Negate('%in%')
##  gSetRanks <- rankings[which(rownames(rankings) %in% geneSet),,drop=FALSE]
##  other_ranking <- rankings[which(rownames(rankings) %notin% geneSet),,drop=FALSE]
##  
##  rm(rankings)
##  
##  aucThreshold <- round(aucMaxRank)
##  ########### NEW version:  #######################
##  x_th <- 1:nrow(gSetRanks)
##  x_th <- sort(x_th[x_th<aucThreshold])
##  y_th <- seq_along(x_th)
##  maxAUC <- sum(diff(c(x_th, aucThreshold)) * y_th) 
##  ############################################
##  
##  # Apply by columns (i.e. to each ranking)
##  auc <- apply(gSetRanks@assays@.xData$data$ranking, 2, .auc2, aucThreshold, maxAUC)
##  pval_correction <- sgof::BH(auc)
##  adj_pval <-pval_correction$Adjusted.pvalues[order(match(pval_correction$data,auc))]
##  names(adj_pval) <- names(auc)
##  return(c(auc, missing=missing, nGenes=nGenes))
##}
##
##.auc <- function(oneRanking=gSetRanks@assays@.xData$data$ranking[,90], aucThreshold, maxAUC)
##{
##  x <- unlist(oneRanking)[1]
##  y <- seq_along(x)
##  sum(diff(c(x, aucThreshold)) * y)/maxAUC
##}
##
##
##barplot(-1*log10(auc))
##barplot(-1*log10(adj_pval))
##calc_rss(label_data,adj_pval,1)
##
##exp_data[which(rownames(exp_data) == "ANAPC11"),1]
##
##
##
##.AUCell_buildRankings <- function(exprMat=exp_data, plotStats=TRUE, nCores=8, keepZeroesAsNA=FALSE, verbose=TRUE)
##{
##  #### Optional. TODO: test thoroughly!
##  if(keepZeroesAsNA){
##    exprMat[which(exprMat==0, arr.ind=TRUE)] <- NA 
##  }
##  #### 
##  
##  if(!data.table::is.data.table(exprMat))
##    exprMat <- data.table::data.table(exprMat, keep.rownames=TRUE)
##  # TO DO: Replace by sparse matrix??? (e.g. dgTMatrix)
##  data.table::setkey(exprMat, "rn") # (reorders rows)
##  
##  nGenesDetected <- numeric(0)
##  msg <- tryCatch(plotGeneCount(exprMat[,-"rn", with=FALSE], plotStats=plotStats, verbose=verbose),
##                  error = function(e) {
##                    return(e)
##                  })
##  if("error" %in% class(msg)) {
##    warning("There has been an error in plotGeneCount() [Message: ",
##            msg$message, "]. Proceeding to calculate the rankings...", sep="")
##  }else{
##    if(is.numeric(nGenesDetected))
##      nGenesDetected <- msg
##  }
##  
##  colsNam <- colnames(exprMat)[-1] # 1=row names
##  if(nCores==1)
##  {
##    # The rankings are saved in exprMat (i.e. By reference)
##    exprMat[, (colsNam):=lapply(-.SD, data.table::frank, ties.method="random", na.last="keep"),
##            .SDcols=colsNam]
##    
##  }else
##  {
##    # doRNG::registerDoRNG(nCores)
##    doParallel::registerDoParallel()
##    options(cores=nCores)
##    
##    if(verbose)
##      message("Using ", foreach::getDoParWorkers(), " cores.")
##    
##    # Expected warning: Not multiple
##    suppressWarnings(colsNamsGroups <- split(colsNam,
##                                             (seq_along(colsNam)) %% nCores))
##    rowNams <- exprMat$rn
##    
##    colsGr <- NULL
##    "%dopar%"<- foreach::"%dopar%"
##    suppressPackageStartupMessages(exprMat <-
##                                     doRNG::"%dorng%"(foreach::foreach(colsGr=colsNamsGroups,
##                                                                       .combine=cbind),
##                                                      {
##                                                        # Edits by reference: how to make it work in paralell...?
##                                                        subMat <- exprMat[,colsGr, with=FALSE]
##                                                        subMat[, (colsGr):=lapply(-.SD, data.table::frank, ties.method="random", na.last="keep"),
##                                                               .SDcols=colsGr]
##                                                      }))
##    # Keep initial order & recover rownames
##    exprMat <- data.table::data.table(rn=rowNams, exprMat[,colsNam, with=FALSE])
##    data.table::setkey(exprMat, "rn")
##  }
##  
##  rn <- exprMat$rn
##  exprMat <- as.matrix(exprMat[,-1])
##  rownames(exprMat) <- rn
##  
##  # return(matrixWrapper(matrix=exprMat, rowType="gene", colType="cell",
##  #                      matrixType="Ranking", nGenesDetected=nGenesDetected))
##  names(dimnames(exprMat)) <- c("genes", "cells")
##  new("aucellResults",
##      SummarizedExperiment::SummarizedExperiment(assays=list(ranking=exprMat)),
##      nGenesDetected=nGenesDetected)
##}
