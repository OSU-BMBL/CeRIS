#!/bin/bash
cores=6
dir=$1
min_length=$2
max_length=$3
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
    /home/www/html/iris3/program/dminda/src/BoBro/BoBro -i $file -l $min_length -F -o 5&
	#perl /home/www/html/iris3/program/dminda/BBR1.pl 1 $file -L $min_length -U $max_length -R 2 -F -n 10 0.4
done
wait
