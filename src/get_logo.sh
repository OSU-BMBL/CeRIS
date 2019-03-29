#!/bin/bash
cores=10
dir=$1
mkdir tomtom
perl /home/www/html/iris3/program/dminda/motif_tools/bobro2align.pl $dir
files="$(find $dir -maxdepth 2 -name "*b2a" -print)"
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
	
	perl /home/www/html/iris3/program/dminda/motif_tools/split_multifasta.pl -i $file -o $dir\/logo &
done
wait



files="$(find $dir -maxdepth 2 -name "*.fsa" -print)"
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
	perl /home/www/html/iris3/program/dminda/motif_tools/align2uniprobe.pl $file | perl /home/www/html/iris3/program/dminda/motif_tools/uniprobe2meme > $file.meme &
	mkdir tomtom/$(basename "$file" .fsa)
	mkdir tomtom/$(basename "$file" .fsa)/HOCOMOCO
	mkdir tomtom/$(basename "$file" .fsa)/JASPAR
	#/home/www/html/iris3/program/meme/bin/tomtom  -no-ssc -oc tomtom/$(basename "$file" .fsa)/HOCOMOCO -verbosity 1 -min-overlap 5 -mi 1 -dist pearson -evalue -thresh 10.0 $file.meme /home/www/html/iris3/program/motif_databases/HUMAN/HOCOMOCOv11_full_HUMAN_mono_meme_format.meme /home/www/html/iris3/program/motif_databases/MOUSE/HOCOMOCOv11_full_MOUSE_mono_meme_format.meme 
	#/home/www/html/iris3/program/meme/bin/tomtom  -no-ssc -oc tomtom/$(basename "$file" .fsa)/JASPAR -verbosity 1 -min-overlap 5 -mi 1 -dist pearson -evalue -thresh 10.0 $file.meme /home/www/html/iris3/program/motif_databases/JASPAR/JASPAR2018_CORE_non-redundant.meme /home/www/html/iris3/program/motif_databases/JASPAR/JASPAR2018_CORE_vertebrates_non-redundant.meme 

	#echo "/home/www/html/iris3/program/meme/bin/tomtom  -no-ssc -oc tomtom/$(basename "$file" .fsa)/HOCOMOCO -verbosity 1 -min-overlap 5 -mi 1 -dist pearson -evalue -thresh 10.0 $file.meme /home/www/html/iris3/program/motif_databases/HUMAN/HOCOMOCOv11_full_HUMAN_mono_meme_format.meme /home/www/html/iris3/program/motif_databases/MOUSE/HOCOMOCOv11_full_MOUSE_mono_meme_format.meme "
	tail -n +2 $file > $file.logo.fa &
perl /home/www/html/bobro2/program/script/weblogo/seqlogo -F PNG -a -n -Y -k 1 -c  -f $file.logo.fa > $file.png &

done
wait


