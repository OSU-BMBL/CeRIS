#!/bin/bash
cores=6
dir=$1
min_length=$2
max_length=$3
is_meme=$4
files="$(find $dir -maxdepth 2 -name "*fa" -print)"
echo "$files"
while read -r species; do COMMAND; 
	for file in $files ;
	do
		while :; do
		background=( $(jobs -p))
		if (( ${#background[@]} < cores )); then
			break
		fi
		sleep 1
		done
		if [ "$is_meme" = "1" ]; then
			#/var/www/html/iris3/program/meme/bin/meme $file -p 8 -w $min_length -allw -mod zoops -nmotifs 10 -text -maxsites 100 -revcomp -dna -oc $file.closures > $file.closures &
			/var/www/html/iris3/program/meme/bin/meme $file -nostatus -w 12 -allw -mod anr -revcomp -nmotifs 10 -objfun de -neg /var/www/html/iris3/program/bg_data/Human.bg.fa -dna -text > $file.meme.closures &
			#/var/www/html/iris3/program/meme/bin/meme bic1.txt.fa -nostatus -w 12 -allw -mod anr -revcomp -nmotifs 10 -csites 1000 -objfun de -neg /var/www/html/iris3/program/bg_data/Human.bg.fa -dna -text > 
			#http://meme-suite.org/info/status?service=MEME&id=appMEME_5.0.51560458259539-1344811313
		else
			/var/www/html/iris3/program/dminda/src/BoBro/BoBro -i $file -l $min_length -F -o 10 -Z /var/www/html/iris3/program/bg_data/$species.bg.fa&
			
		fi
		
		#perl /var/www/html/iris3/program/dminda/BBR1.pl 1 $file -L $min_length -U $max_length -R 2 -F -n 10 0.4
	done
done < $dir/species.txt
wait
