#!/bin/bash
cores=8
dir=$1

files="$(find $dir -maxdepth 2 -name "*fa" -print)"
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
    /home/www/html/iris3/program/dminda/src/BoBro/BoBro -i $file &
	
done
