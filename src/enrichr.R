#install.packages("enrichR")
library(enrichR)


setwd('D:/Users/flyku/Documents/IRIS3-R/test/13')
srcDir <- getwd()
regulon_file <- list.files(srcDir, pattern = "*.regulon_gene_name.txt")
#i=regulon_file[1]
#j=all_text[1]
result <- data.frame()
for (i in regulon_file) {
  this_file <- file(i)
  all_text <- readLines(this_file)
  for (j in all_text) {
    this_str <- strsplit(j,"\t")[[1]][-1]
    regulon_idx <- strsplit(j,"\t")[[1]][1]
    dbs <- listEnrichrDbs()
    dbs <- c("GO_Molecular_Function_2018", "GO_Cellular_Component_2018", "GO_Biological_Process_2018")
    
    enriched <- enrichr(this_str, dbs)
    min_adj_pval_bp <- min(enriched[["GO_Biological_Process_2018"]]$Adjusted.P.value)
    min_adj_pval_cc <- min(enriched[["GO_Cellular_Component_2018"]]$Adjusted.P.value)
    min_adj_pval_mf <- min(enriched[["GO_Molecular_Function_2018"]]$Adjusted.P.value)
    this_df <- data.frame(i,regulon_idx,min_adj_pval_bp,min_adj_pval_cc,min_adj_pval_mf)
    result <- rbind(result,this_df)
  }
}

write.table(result,"pval.txt",sep="\t",quote=F)
