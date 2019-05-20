#!/bin/bash
dir=$1

files="$(find $dir -maxdepth 2 -name "*fa" -print)"
echo "$files"
for file in $files ;
do
/var/www/html/iris3/program/meme/bin/meme /var/www/html/iris3/data/20181124190953/20181124190953_CT_7_bic/bic1.txt.fa -minw 6 -maxw 20 -allw -mod zoops -nmotifs 5 -oc $(basename /var/www/html/iris3/data/20181124190953/20181124190953_CT_7_bic/bic1.txt.fa.closures) 
	
done



find /var/www/html/iris3/data/20181124190953 -maxdepth 2 -name "*fa" -print

/var/www/html/iris3/program/meme/bin/meme bic2.txt.fa -p 8 -w 12 -allw -mod zoops -nmotifs 5 -text -maxsites 100 -oc bic2.txt.fa.closures > bic2.txt.fa.closures1


cat fur_1168121.fa | while read L; do  echo $L; read L; echo "$L" | rev | tr "ATGC" "TACG" ; done
