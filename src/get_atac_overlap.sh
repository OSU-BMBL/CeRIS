#!/bin/bash

# input (1,1,1) 
dir=$1
atac_dir=/var/www/html/iris3/program/human_atac_seq
mkdir atac
files="$(find $dir -maxdepth 2 -name "*.regulon_motif.txt" -print)"
bed_files="$(find $atac_dir -maxdepth 2 -name "*.bed" )"
#echo $bed_files
for file in $files
do
	while IFS=$'\t' read -r -a myArray
	do
		regex=$( IFS='|'; echo "${myArray[*]}" )
		celltype=$(echo $myArray | sed 's/[0-9].*//')
		awk -v str="$regex" -v ct="$celltype" '$6 ~ str && $5 ~ ct' motif_position.bed > atac/$myArray.bed
		#for atac_bed in $bed_files
		#do
		#	bedtools intersect -a atac/$myArray.bed -b $atac_bed | awk -F '\t' '{print $4}'  | sort | uniq -c | sort -nr| wc -l >> atac/$myArray.atac_overlap.txt
		#done
		#bedtools intersect -a CT1S-R1.bed -b 61492_peaks.bed| awk -F '\t' '{print $4}'  | sort | uniq -c | sort -nr| wc -l
	done < $file
done

