#!/bin/bash
cores=10
dir=$1
mkdir tomtom

files="$(find $dir -maxdepth 2 -name "*.meme" -print)"
echo "$files"
for file in $files ;
do
	while :; do
    background=( $(jobs -p))
    if (( ${#background[@]} < cores )); then
        break
    fi
    sleep 1
	done
	mkdir tomtom/$(basename "$file" .fsa.meme)
	mkdir tomtom/$(basename "$file" .fsa.meme)/HOCOMOCO
	mkdir tomtom/$(basename "$file" .fsa.meme)/JASPAR
	nohup /home/www/html/iris3/program/meme/bin/tomtom  -no-ssc -oc tomtom/$(basename "$file" .fsa.meme)/HOCOMOCO -verbosity 1 -min-overlap 5 -mi 1 -dist pearson -evalue -thresh 10.0 $file /home/www/html/iris3/program/motif_databases/HUMAN/HOCOMOCOv11_full_HUMAN_mono_meme_format.meme /home/www/html/iris3/program/motif_databases/MOUSE/HOCOMOCOv11_full_MOUSE_mono_meme_format.meme &
	#nohup /home/www/html/iris3/program/meme/bin/tomtom  -no-ssc -oc tomtom/$(basename "$file" .fsa.meme)/JASPAR -verbosity 1 -min-overlap 5 -mi 1 -dist pearson -evalue -thresh 10.0 $file /home/www/html/iris3/program/motif_databases/JASPAR/JASPAR2018_CORE_non-redundant.meme /home/www/html/iris3/program/motif_databases/JASPAR/JASPAR2018_CORE_vertebrates_non-redundant.meme &
	nohup /home/www/html/iris3/program/meme/bin/tomtom  -no-ssc -oc tomtom/$(basename "$file" .fsa.meme)/JASPAR -verbosity 1 -min-overlap 5 -mi 1 -dist pearson -evalue -thresh 10.0 $file /home/www/html/iris3/program/motif_databases/JASPAR/JASPAR2018_CORE_non-redundant.meme &

	#echo "/home/www/html/iris3/program/meme/bin/tomtom  -no-ssc -oc tomtom/$(basename "$file" .fsa)/HOCOMOCO -verbosity 1 -min-overlap 5 -mi 1 -dist pearson -evalue -thresh 10.0 $file.meme /home/www/html/iris3/program/motif_databases/HUMAN/HOCOMOCOv11_full_HUMAN_mono_meme_format.meme /home/www/html/iris3/program/motif_databases/MOUSE/HOCOMOCOv11_full_MOUSE_mono_meme_format.meme "
done
wait


