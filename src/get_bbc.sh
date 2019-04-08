#!/bin/bash

dir=$1

bbc_files="$(find $dir -maxdepth 1 -name "*CT*.bbc.txt" | sort -nr)"

cd $dir
> combine_bbc.bbc.txt
for file in $bbc_files
do
	bbcname=$(basename "$file")
	ctname="$(grep -oP '(?<=_).*?(?=_bic)' <<< $bbcname)"
	#echo $ctname
	head -n -1 $file > $file.tmp
	perl -pi -e "s/^>/>$ctname-/g" $file.tmp
done

cat *.bbc.txt.tmp > combine_bbc.bbc.txt
echo '>end' >> combine_bbc.bbc.txt
rm *.bbc.txt.tmp
files="$(find $dir -maxdepth 2 -name "20*.bbc.txt" -print)"
for file in $files ;
do
	#echo "$file"
	fbname=$(basename "$file")
	#pval_fbname=$(basename "$pval_files")
	#perl /home/www/html/iris3/program/sort_bbc.pl $fbname $pval_fbname > $fbname.1

	#samtools faidx $fbname
	#samtools faidx $fbname $(cat $pval_fbname) > $fbname.sorted
	#echo "samtools $fbname $(cat $pval_fbname) > $fbname.sorted"
	#fold -w 12 -s bbc.1 > $fbname
	#rm tmp.idx
	#echo '>end' >> $fbname
	perl /home/www/html/iris3/program/dminda/BBC.pl bg $fbname -1 0.4 0.8
done

perl /home/www/html/iris3/program/dminda/BBC.pl bg combine_bbc.bbc.txt -1 0.4 0.8