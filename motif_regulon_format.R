library(tidyverse)
library(rjson)

motif_file <- fromJSON(file = "json_array.txt")
motif_df <- as.data.frame(motif_file)
