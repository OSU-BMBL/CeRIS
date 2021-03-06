#!/bin/bash
cores=8
dir=$1
#mkdir tomtom
species=$(head -n 1 species_main.txt)
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
	#mkdir tomtom/$(basename "$file" .fsa.meme)/HOCOMOCO
	#mkdir tomtom/$(basename "$file" .fsa.meme)/JASPAR
	#hocomoco
	#nohup /var/www/html/CeRIS/program/meme/bin/tomtom  -no-ssc -oc tomtom/$(basename "$file" .fsa.meme)/HOCOMOCO -verbosity 1 -min-overlap 5 -mi 1 -dist pearson -evalue -thresh 10.0 $file /var/www/html/CeRIS/program/motif_databases/HUMAN/HOCOMOCOv11_full_HUMAN_mono_meme_format.meme /var/www/html/CeRIS/program/motif_databases/MOUSE/HOCOMOCOv11_full_MOUSE_mono_meme_format.meme &
	#nohup /var/www/html/CeRIS/program/meme/bin/tomtom  -no-ssc -oc tomtom/$(basename "$file" .fsa.meme)/JASPAR -verbosity 1 -min-overlap 5 -mi 1 -dist pearson -evalue -thresh 10.0 $file /var/www/html/CeRIS/program/motif_databases/JASPAR/JASPAR2018_CORE_non-redundant.meme /var/www/html/CeRIS/program/motif_databases/JASPAR/JASPAR2018_CORE_vertebrates_non-redundant.meme &
	# jaspar
	#nohup /var/www/html/CeRIS/program/meme/bin/tomtom  -no-ssc -oc tomtom/$(basename "$file" .fsa.meme)/JASPAR -verbosity 1 -min-overlap 5 -mi 1 -dist pearson -evalue -thresh 10.0 $file /var/www/html/CeRIS/program/motif_databases/JASPAR/JASPAR2018_CORE_non-redundant.meme &

	#echo "/var/www/html/CeRIS/program/meme/bin/tomtom  -no-ssc -oc tomtom/$(basename "$file" .fsa)/HOCOMOCO -verbosity 1 -min-overlap 5 -mi 1 -dist pearson -evalue -thresh 10.0 $file.meme /var/www/html/CeRIS/program/motif_databases/HUMAN/HOCOMOCOv11_full_HUMAN_mono_meme_format.meme /var/www/html/CeRIS/program/motif_databases/MOUSE/HOCOMOCOv11_full_MOUSE_mono_meme_format.meme "
	#default from tomtom website
	#nohup /var/www/html/CeRIS/program/meme/bin/tomtom  -no-ssc -oc tomtom/$(basename "$file" .fsa.meme)/ -verbosity 1 -min-overlap 5 -mi 1 -dist pearson -evalue -thresh 10.0 $file /var/www/html/CeRIS/program/motif_databases/EUKARYOTE/jolma2013.meme /var/www/html/CeRIS/program/motif_databases/JASPAR/JASPAR2018_CORE_vertebrates_non-redundant.meme /var/www/html/CeRIS/program/motif_databases/MOUSE/uniprobe_mouse.meme &
	#TOMTOM human&mouse 
	#nohup /var/www/html/CeRIS/program/meme/bin/tomtom  -no-ssc -oc tomtom/$(basename "$file" .fsa.meme)/ -verbosity 1 -min-overlap 5 -mi 1 -dist pearson -evalue -thresh 10.0 $file /var/www/html/CeRIS/program/motif_databases/HUMAN/HOCOMOCOv11_full_HUMAN_mono_meme_format.meme /var/www/html/CeRIS/program/motif_databases/MOUSE/HOCOMOCOv11_full_MOUSE_mono_meme_format.meme &
	if [ "$species" == "Human" ]; then
	nohup /var/www/html/CeRIS/program/meme/bin/tomtom  -no-ssc -oc tomtom/$(basename "$file" .fsa.meme)/ -verbosity 1 -min-overlap 5 -mi 1 -dist pearson -evalue -thresh 0.05 $file /var/www/html/CeRIS/program/motif_databases/HUMAN/HOCOMOCOv11_full_HUMAN_mono_meme_format.meme &
	fi
	if [ "$species" == "Mouse" ]; then
	nohup /var/www/html/CeRIS/program/meme/bin/tomtom  -no-ssc -oc tomtom/$(basename "$file" .fsa.meme)/ -verbosity 1 -min-overlap 5 -mi 1 -dist pearson -evalue -thresh 0.05 $file /var/www/html/CeRIS/program/motif_databases/MOUSE/HOCOMOCOv11_full_MOUSE_mono_meme_format.meme &
fi
done
wait


