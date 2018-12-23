#!/bin/bash
cores=8
dir=$1
files="$(find $dir -name "*.heatmap.txt")"
#echo "$files"
for file in $files ;
do
	while :; do
    background=( $(jobs -p))
    if (( ${#background[@]} < cores )); then
        break
    fi
    sleep 1
	done
	out="$(basename $file .heatmap.txt)"
	echo $file $out $dir
    python /home/www/html/iris3/program/clustergrammer/make_clustergrammer.py $file $out $dir&
done
wait
