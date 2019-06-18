#!/bin/bash

# input format: 1,1,1
dir=$1
atac_dir=/var/www/html/iris3/program/db/human_atac_seq
mkdir atac
files="$(find $dir -maxdepth 2 -name "*.regulon_motif.txt" -print)"
bed_files="$(find $atac_dir -maxdepth 2 -name "*.bed" )"
for file in $files
do
	while IFS=$'\t' read -r -a myArray
	do
		regex=$( IFS='|'; echo "${myArray[*]}" )
		celltype=$(echo $myArray | sed 's/[0-9].*//')
		awk -v str="$regex" -v ct="$celltype" '$6 ~ str && $5 ~ ct' motif_position.bed > atac/$myArray.bed
	done < $file
done

