
########## Test DMINDA and MEME overlap ##################
# used files:
# regulon_motif

library(dabestr)
###test
wd <- "d:/Users/flyku/Documents/IRIS3-data/20190816170235"
jobid <-20190816170235 
# wd <- getwd()
setwd(wd)

quiet <- function(x) { 
  sink(tempfile()) 
  on.exit(sink()) 
  invisible(force(x)) 
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

#i=1
total_motif_list <- list()
total_rank_list <- list()
for (i in 1:length(alldir)) {
  regulon_motif_handle <- file(paste(jobid,"_CT_",i,"_bic.regulon_motif.txt",sep = ""),"r")
  regulon_motif <- readLines(regulon_motif_handle)
  close(regulon_motif_handle)
  motif_list <- lapply(strsplit(regulon_motif,"\\t"), function(x){x})
  
  regulon_rank_handle <- file(paste(jobid,"_CT_",i,"_bic.regulon_rank.txt",sep = ""),"r")
  regulon_rank <- readLines(regulon_rank_handle)
  close(regulon_rank_handle)
  rank_list <- lapply(strsplit(regulon_rank,"\\t"), function(x){x})
  total_motif_list <- append(total_motif_list,motif_list)
  total_rank_list <- append(total_rank_list,rank_list)
}


multiple_motif <- unlist(lapply(total_motif_list, function(x){
  length(x) >= 3
})
)
total_regulon <- length(total_motif_list)
total_multiple_regulon <- length(which(multiple_motif == T))
multiple_motif <- total_motif_list[which(multiple_motif == T)]
total_motif_list[multiple_motif]
length(multiple_motif)




total_both_meme_dminda_regulon <- length(unlist(lapply(total_motif_list, function(x){
  if (length(x) > 2) {
    for (i in 2:length(x)) {
      if(as.numeric(strsplit(x,",")[[2]][2])>100 && as.numeric(strsplit(x,",")[[i]][2])<100){
        return(strsplit(x,",")[[2]][2])
      } else if(as.numeric(strsplit(x,",")[[2]][2])<100 && as.numeric(strsplit(x,",")[[i]][2])>100){
        return(strsplit(x,",")[[2]][2])
      }
    }
  }
})))
x <- total_motif_list[[1]]
both_meme_dminda_regulon_id <- unlist(lapply(total_motif_list, function(x){
  if (length(x) > 2) {
    for (i in 2:length(x)) {
      if(as.numeric(strsplit(x,",")[[2]][2])>100 && as.numeric(strsplit(x,",")[[i]][2])<100){
        return(x[[1]])
      } else if(as.numeric(strsplit(x,",")[[2]][2])<100 && as.numeric(strsplit(x,",")[[i]][2])>100){
        return(x[[1]])
      }
    }
  }
}))

x <- total_rank_list[[1]]
both_meme_dminda_regulon_rss <- unlist(lapply(total_rank_list, function(x){
  if (x[[1]] %in% both_meme_dminda_regulon_id){
    return (x[[5]])
  }
}))




meme_total_motif <- length(unlist(lapply(total_motif_list, function(x){
  if(as.numeric(strsplit(x,",")[[2]][2])>100){
    return(strsplit(x,",")[[2]][2])
  }
})))

meme_regulon_id <- unlist(lapply(total_motif_list, function(x){
      if(as.numeric(strsplit(x,",")[[2]][2])>100){
        return(x[[1]])
      } 
}))
meme_regulon_rss <-  unlist(lapply(total_rank_list, function(x){
  if (x[[1]] %in% meme_regulon_id){
    return (x[[5]])
  }
}))


x <- total_rank_list[[1]]
both_meme_dminda_regulon_rss <- unlist(lapply(total_rank_list, function(x){
  if (x[[1]] %in% both_meme_dminda_regulon_id){
    return (x[[5]])
  }
}))

dminda_total_motif <- length(unlist(lapply(total_motif_list, function(x){
  if(as.numeric(strsplit(x,",")[[2]][2])<100){
    return(strsplit(x,",")[[2]][2])
  }
})))


dminda_regulon_id <- unlist(lapply(total_motif_list, function(x){
  if(as.numeric(strsplit(x,",")[[2]][2])<100){
    return(x[[1]])
  } 
}))
dminda_regulon_rss <-  unlist(lapply(total_rank_list, function(x){
  if (x[[1]] %in% dminda_regulon_id){
    return (x[[5]])
  }
}))
df1 <- data.frame(value=as.numeric(both_meme_dminda_regulon_rss),group="dminda_and_meme")
df2 <- data.frame(value=as.numeric(meme_regulon_rss),group="meme_only")
df3 <- data.frame(value=as.numeric(dminda_regulon_rss),group="dminda_only")
df <- rbind(df1,df2,df3)

#colnames(df) <- c("dminda_and_meme","meme_only","dminda_only")

unpaired_mean_diff <- dabest(df,group, value,
                             idx =  c("dminda_and_meme","meme_only","dminda_only"),
                             paired = FALSE)

plot(unpaired_mean_diff)
total_regulon
total_multiple_regulon