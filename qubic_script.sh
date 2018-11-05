#!/bin/bash
workdir=/home/www/html/iris3/program/test/
exp_file=Yan_expression.csv
label_file=Yan_cell_label.csv
jobid=20181103

Rscript /home/www/html/iris3/program/genefilter.R $workdir$exp_file $jobid ,
/home/www/html/iris3/program/qubic/qubic -i $workdir$jobid\_filtered_expression.txt -d -f 0.5 -c 1 -k 18 -o 5000
for file in *blocks
do
grep Conds $file |cut -d ':' -f2 >"$(basename $jobid\_blocks.conds.txt)"
done

for file in *blocks
do
grep Genes $file |cut -d ':' -f2 >"$(basename $jobid\_blocks.gene.txt)"
done

Rscript /home/www/html/iris3/program/ari_score.R $label_file $jobid 3

Rscript /home/www/html/iris3/program/cts_gene_list.R $workdir$jobid\_filtered_expression.txt $jobid $workdir$jobid\_cell_label.txt

