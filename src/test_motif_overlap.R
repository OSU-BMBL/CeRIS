
########## Test DMINDA and MEME overlap ##################
# used files:
# regulon_motif


###test
wd <- "C:/Users/wan268/Documents/iris3_data/20190726151055"
jobid <-20190726151055 
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
for (i in 1:length(alldir)) {
  regulon_motif_handle <- file(paste(jobid,"_CT_",i,"_bic.regulon_motif.txt",sep = ""),"r")
  regulon_motif <- readLines(regulon_motif_handle)
  close(regulon_motif_handle)
  motif_list <- lapply(strsplit(regulon_motif,"\\t"), function(x){x[-1]})
  total_motif_list <- append(total_motif_list,motif_list)
}

single_motif <- unlist(lapply(total_motif_list, function(x){
  length(x) >= 2
})
)


which(single_motif == F)

