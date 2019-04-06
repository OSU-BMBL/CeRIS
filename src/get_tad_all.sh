#!/bin/bash

# 
dir=/home/www/html/iris3/program/tad/mm10
#dir=/home/www/html/iris3/program/tad/hg38

files="$(find $dir -maxdepth 2 -name "*.domains" -print)"
bed_files="$(find $atac_dir -maxdepth 2 -name "*.bed" )"
#echo $bed_files
for file in $files
do
	bedtools intersect -a $file -b /home/www/html/iris3/program/dminda/mouse_gene_info.bed -wa -wb > $file.bed 
done

