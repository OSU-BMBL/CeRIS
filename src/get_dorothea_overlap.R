#######  get DoRothEA overlaped genes report the score in this regulon ##########

library(tibble)
library(readr)
args <- commandArgs(TRUE)

# regulon <- 'CT1S-R2'
# jobid <- '2019101504402'
# species <- 'Human'

regulon <- args[1] # CT3S-R5
species <- args[2] #Human, Mouse
jobid <- args[3]
this_tf <- args[4]

wd <- paste("/var/www/html/iris3/data/",jobid,sep="")
setwd(wd)
if (species == "Human") {
  tf_db <- read_tsv(paste("/var/www/html/iris3/program/db/human_tfregulons_database_v01_20180216__limit.tsv"))
} else if (species == "Mouse"){
  tf_db <- read_tsv(paste("/var/www/html/iris3/program/db/mouse_tfregulons_database_v01_20180216__limit.tsv"))
}

# parse 'CT3S-R5' to 'CT', '3', '5'
#regulon_ct <- strsplit(regulon,"S-R")[[1]][1]
#regulon_ct <- gsub( "[0-9].*$", "", regulon )
# regulon= 'modul1-R2'
# regulon= 'CT1S-R2'
regulon_type <- gsub( "[0-9].*$", "", regulon)
regulon_type_id <-gsub( "S.*$", "", regulon)
regulon_type_id <-gsub( "-.*$", "", regulon_type_id)
regulon_type_id <-gsub("[[:alpha:]]","",regulon_type_id)
regulon_id <- gsub( ".*R", "", regulon)
regulon_id <- gsub("[[:alpha:]]","",regulon_id)

regulon_filename <- paste(jobid,"_",regulon_type,"_",regulon_type_id,"_bic.regulon_gene_symbol.txt",sep="")
gene_id_name <- read.table(paste(jobid,"_gene_id_name.txt",sep=""),header = T)
regulon_file_connection <- file(regulon_filename)
regulon_file <- strsplit(readLines(regulon_file_connection), "\t")
close(regulon_file_connection)
regulon_gene_list <- regulon_file[[as.numeric(regulon_id)]][-1]


this_tf_db <- tf_db[which(tf_db[,1] == this_tf),]
result_gene_mapping <- this_tf_db[this_tf_db[,2] %in% regulon_gene_list,]
#result_gene_mapping <- this_tf_db[1:10,]
if(nrow(result_gene_mapping) > 0){
  write.table(result_gene_mapping,paste("regulon_id/",regulon,".dorothea_overlap.txt",sep = ""),quote = F,row.names = F,sep = "\t",col.names = F)
} else {
  write.table(t(matrix(rep(NA,3))) ,paste("regulon_id/",regulon,".dorothea_overlap.txt",sep = ""),quote = F,row.names = F,sep = "\t",col.names = F)
}
