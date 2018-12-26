#!/bin/bash
 
#User uploaded cell label
wd=/home/www/html/iris3/data/20181225212004/
exp_file=iris3_example_expression_matrix.csv
label_file=iris3_example_expression_label.csv
jobid=20181225212004
motif_min_length=12
motif_max_length=12
Rscript /home/www/html/iris3/program/genefilter.R $wd$exp_file $jobid ,
/home/www/html/iris3/program/qubic/qubic -i $wd$jobid\_filtered_expression.txt -d -f 0.5 -c 1.0 -k 18 -o 200
for file in *blocks
do
grep Conds $file |cut -d ':' -f2 >"$(basename $jobid\_blocks.conds.txt)"
done
for file in *blocks
do
grep Genes $file |cut -d ':' -f2 >"$(basename $jobid\_blocks.gene.txt)"
done
Rscript /home/www/html/iris3/program/sc3.R $wd$jobid\_filtered_expression.txt $jobid $label_file , 

Rscript /home/www/html/iris3/program/ari_score.R $label_file $jobid , 1
Rscript /home/www/html/iris3/program/cts_gene_list.R $wd$jobid\_filtered_expression.txt $jobid $wd$jobid\_cell_label.txt

Rscript /home/www/html/iris3/program/cvt_symbol.R $wd $wd$jobid\_filtered_expression.txt
 
perl /home/www/html/iris3/program/prepare_promoter.pl $wd

/home/www/html/iris3/program/get_motif.sh $wd $motif_min_length $motif_max_length

wait
cd $wd

find -name '*' -size 0 -delete

Rscript /home/www/html/iris3/program/prepare_bbc.R $wd

touch bg 

/home/www/html/iris3/program/get_bbc.sh $wd

Rscript /home/www/html/iris3/program/merge_bbc.R $wd $jobid $motif_min_length

Rscript /home/www/html/iris3/program/prepare_heatmap.R $wd $jobid
mkdir json
/home/www/html/iris3/program/build_clustergrammar.sh $wd
mkdir tomtom

mkdir logo_tmp

mkdir logo

/home/www/html/iris3/program/get_logo.sh $wd

 
perl /home/www/html/iris3/program/prepare_email.pl $jobid

touch done
