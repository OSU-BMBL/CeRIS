#install.packages("enrichR")
library(enrichR)

# check all enrichr databases
dbs <- listEnrichrDbs()

# read regulon-gene file


job <- read.table("/var/www/html/CeRIS/data/20191101133117/job",sep="\t")
job <- job[c(-5,-6,-14,-16),]

job_list <- as.character(job$V1)
output <- data.frame()


for (i in 1:length(job_list)) {
  #system(paste("chmod 777 ",job_list[i],"_combine_regulon.txt",sep = "")) 
  
  wd <- paste("/var/www/html/CeRIS/data/",job_list[i],sep="")
  combine_result <-read.table(paste(job_list[i],"_combine_regulon.txt",sep = ""), sep="\t",header = T)
  setwd(wd)
  species <- as.character(read.table("species_main.txt"))
  if (species == "Human") {
    test.terms <- c("ENCODE_TF_ChIP-seq_2015","WikiPathways_2015", 
                    "KEGG_2019_Human", "Enrichr_Submissions_TF-Gene_Coocurrence")
    
  } else if (species == "Mouse"){
    test.terms <- c("ENCODE_TF_ChIP-seq_2015","WikiPathways_2015", 
                    "KEGG_2019_Mouse", "Enrichr_Submissions_TF-Gene_Coocurrence")
  }
  
  KEGG <- data.frame()
  Wiki <- data.frame()
  ENCODE <- data.frame()
  
  KEGG_reg_num <- 0
  Wiki_reg_num <- 0
  ENCODE_reg_num <-0
  regulon <- strsplit(combine_result$gene_symbol,",")
  
  for (j in regulon){
    enriched <- enrichr(j, test.terms)
    # subset enrichment results: terms, number of genes, adj.p-value
    KEGG_reg <- enriched[[3]][,c(1:2,4)]
    Wiki_reg <- enriched$WikiPathways_2015[,c(1:2,4)]
    ENCODE_reg <- enriched$`ENCODE_TF_ChIP-seq_2015`[,c(1:2,4)]
    #Coocurrence_reg <- enriched$`Enrichr_Submissions_TF-Gene_Coocurrence`[,c(1:2,4)]
    # find significantly enriched terms
    KEGG_reg <- KEGG_reg[which(KEGG_reg[,3]<=0.05),]
    Wiki_reg <- Wiki_reg[which(Wiki_reg[,3]<=0.05),]
    ENCODE_reg <- ENCODE_reg[which(ENCODE_reg[,3]<=0.05),]
    #Coocurrence_reg <- Coocurrence_reg[which(Coocurrence_reg[,3]<=0.05),]
    # combine term lists
    KEGG <- rbind(KEGG,KEGG_reg)
    Wiki <- rbind(Wiki,Wiki_reg)
    ENCODE <- rbind(ENCODE,ENCODE_reg)
    #Coocurrence <- rbind(Coocurrence,Coocurrence_reg)
    # count # of CTSRs significantly enriched at least one term
    if(nrow(KEGG_reg)>0){
      KEGG_reg_num <- KEGG_reg_num+1
    }  
    if(nrow(Wiki_reg)>0){
      Wiki_reg_num <- Wiki_reg_num+1
    }
    if(nrow(ENCODE_reg)>0){
      ENCODE_reg_num <- ENCODE_reg_num+1
    }  
  }
  
  # calculate precision (change length to nrow for real regulon list)
  KEGG_pre <- KEGG_reg_num/length(regulon)
  Wiki_pre <- Wiki_reg_num/length(regulon)
  ENCODE_pre <- ENCODE_reg_num/length(regulon)
  
  # calculate recall
  # ENCODE_TF_ChIP-seq_2015, 20382, 1811, 816
  # WikiPathways_2015, 5963, 51, 404
  # KEGG_2019_Human, 7802, 92, 308 
  # KEGG_2019_Mouse, 8551, 98, 303
  Wiki_recall <- length(unique(Wiki[,1]))/404
  ENCODE_recall <- length(unique(ENCODE[,1]))/816
  if (species == "Human") {
    KEGG_recall <- length(unique(KEGG[,1]))/308
  } else if (species == "Mouse"){
    KEGG_recall <- length(unique(KEGG[,1]))/303
  }
  
  # calculate F-score
  KEGG_F <- 2/(1/KEGG_pre+1/KEGG_recall)
  Wiki_F <- 2/(1/Wiki_pre+1/Wiki_recall)
  ENCODE_F <- 2/(1/ENCODE_pre+1/ENCODE_recall)
  this_output <- c(as.character(job[i,2]),KEGG_F,Wiki_F,ENCODE_F)
  output <- rbind(output,this_output)
}

colnames(output) <- c("data","KEGG","WIKI")
write.table(Wiki,"Wiki_enrichment_result.txt")

# export file
#KEGG <- rbind(KEGG_F, KEGG)
#Wiki <- rbind(KEGG_F, Wiki)
#ENCODE <- rbind(KEGG_F, ENCODE)
#write.table(KEGG,"KEGG_enrichment_result.txt")
#write.table(Wiki,"Wiki_enrichment_result.txt")
#write.table(ENCODE,"ENCODE_enrichment_result.txt")




