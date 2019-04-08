<?php
// include "head.html";
set_time_limit(300);
require("config/common.php");
require("config/smarty.php");

$smarty->caching = true;
$smarty->assign('section', 'Homepage');
session_start();

function get_client_ip_server() {
    $ipaddress = '';
    if ($_SERVER['HTTP_CLIENT_IP'])
        $ipaddress = $_SERVER['HTTP_CLIENT_IP'];
    else if($_SERVER['HTTP_X_FORWARDED_FOR'])
        $ipaddress = $_SERVER['HTTP_X_FORWARDED_FOR'];
    else if($_SERVER['HTTP_X_FORWARDED'])
        $ipaddress = $_SERVER['HTTP_X_FORWARDED'];
    else if($_SERVER['HTTP_FORWARDED_FOR'])
        $ipaddress = $_SERVER['HTTP_FORWARDED_FOR'];
    else if($_SERVER['HTTP_FORWARDED'])
        $ipaddress = $_SERVER['HTTP_FORWARDED'];
    else if($_SERVER['REMOTE_ADDR'])
        $ipaddress = $_SERVER['REMOTE_ADDR'];
    else
        $ipaddress = 'UNKNOWN';
 
    return $ipaddress;
}
function detectDelimiter($csvFile)
{
    $delimiters = array(
        ';' => 0,
        ',' => 0,
        "\t" => 0,
        "|" => 0,
		" " => 0,
    );

    $handle = fopen($csvFile, "r");
    $firstLine = fgets($handle);
    fclose($handle); 
    foreach ($delimiters as $delimiter => &$count) {
        $count = count(str_getcsv($firstLine, $delimiter));
    }

    return array_search(max($delimiters), $delimiters);
}
if (isset($_POST['submit']))
{
	session_start();
	file_put_contents("/home/www/html/iris3/ip.txt",PHP_EOL .get_client_ip_server(), FILE_APPEND | LOCK_EX);
	//$jobid = date("YmdGis");
	$jobid = $_SESSION['jobid'];
	
	$workdir = "./data/$jobid";
	mkdir($workdir);
	$if_allowSave = $_POST['allowstorage'];
	$is_gene_filter = $_POST['is_gene_filter'];
	if($is_gene_filter =="") {
		$is_gene_filter = '0';
	}
	$is_cell_filter = $_POST['is_cell_filter'];
	if($is_cell_filter =="") {
		$is_cell_filter = '0';
	}
	
	if($if_allowSave =="") {
		$if_allowSave = '0';
	}
	$email = $_POST['email'];
	$c_arg = '1.0';
	$f_arg = '0.5';
	$o_arg = '100';
	$promoter_arg = '1000';
	$param_k = '0';
	$c_arg = $_POST['c_arg'];
	$f_arg = $_POST['f_arg'];
	$o_arg = $_POST['o_arg'];
	$promoter_arg = $_POST['promoter_arg'];
	$enable_sc3_k = $_POST['enable_sc3_k'];
	if($enable_sc3_k == "specify"){
		$param_k = $_POST['param_k'];
		if ($param_k == ""){
			$param_k = '0';
		}
	}
	$motif_program = $_POST['motif_program'];
	$expfile = $_SESSION['expfile'];
	$labelfile = $_SESSION['labelfile'];
	$gene_module_file = $_SESSION['gene_module_file'];

	$bic_inference = $_POST['bicluster_inference'];
	if( $expfile!='iris3_example_expression_matrix.csv' && $labelfile == 'iris3_example_expression_label.csv'){
		$labelfile = "";
	}
	if( $expfile!='iris3_example_expression_matrix.csv' && $gene_module_file == 'iris3_example_gene_module.csv'){
		$gene_module_file = "";
	}
	$len = strlen($labelfile);
	if($bic_inference=='1' && strlen($labelfile) > 0){#have label use sc3
		$label_use_sc3 = '1';
	} else if ($bic_inference=='2' && strlen($labelfile) > 0){ # have label use label
		$label_use_sc3 = '2';
	} else { #no label use sc3
		$label_use_sc3 = '0';
	}

	
	if($c_arg == '1.0' && $f_arg == '0.5' && $o_arg == '1000000' && $motif_program == '0' && $label_use_sc3 == '1' && $expfile=='iris3_example_expression_matrix.csv' && $labelfile == 'iris3_example_expression_label.csv'){
		
		header("Location: results.php?jobid=20190327230542#");
	}
	
	else {
	system("touch $workdir/email.txt");
	system("chmod 777 $workdir/email.txt");
	$fp = fopen("$workdir/email.txt", 'w');
	if($email == ""){
		$email = "flykun0620@gmail.com";
	}
    fwrite($fp,"$email");
	
    fclose($fp);
	//$fp = fopen("$workdir/info.txt", 'w');
	//fwrite($fp,"$c_arg\t$f_arg\t$o_arg\t$motif_program\t$label_use_sc3\t$expfile\t$labelfile\t");
	//fclose($fp);
	$workdir2 = "./data/$jobid/";
	
	#$delim = detectDelimiter($expfile);
#	header("Location: warning.php");
	#system("touch $workdir2/status.txt");
	
	$delim = detectDelimiter("$workdir2/$expfile");
	if($delim=="\t"){
		$delim = "tab";
	}
	$delim_label = detectDelimiter("$workdir2/$labelfile");
		if($delim_label=="\t"){
		$delim_label = "tab";
	}
	$delim_gene_module = detectDelimiter("$workdir2/$gene_module_file");
		if($delim_gene_module=="\t"){
		$delim_gene_module = "tab";
	}
	$fp = fopen("$workdir/info.txt", 'w');
	fwrite($fp,"c_arg,$c_arg\nf_arg,$f_arg\no_arg,$o_arg\nmotif_program,$motif_program\nlabel_use_sc3,$label_use_sc3\nexpfile,$expfile\nlabelfile,$labelfile\nis_gene_filter,$is_gene_filter\nis_cell_filter,$is_cell_filter\nif_allowSave,$if_allowSave\nbic_inference,$bic_inference");
	fclose($fp);
	$fp = fopen("$workdir2/qsub.sh", 'w');
	if($if_allowSave != '0'){
    system("cp $workdir2$expfile /home/www/html/iris3/storage");
	}

	
if ($labelfile != ''){
fwrite($fp,"#!/bin/bash\n 
#User uploaded cell label
wd=/home/www/html/iris3/data/$jobid/
exp_file=$expfile
label_file=$labelfile
gene_module_file=$gene_module_file
jobid=$jobid
motif_min_length=12
motif_max_length=12
Rscript /home/www/html/iris3/program/genefilter.R \$wd\$exp_file \$jobid $delim $is_gene_filter $is_cell_filter
/home/www/html/iris3/program/qubic/qubic -i \$wd\$jobid\_filtered_expression.txt -d -f $f_arg -c $c_arg -k 18 -o $o_arg
for file in *blocks
do
grep Conds \$file |cut -d ':' -f2 >\"$(basename \$jobid\_blocks.conds.txt)\"
done
for file in *blocks
do
grep Genes \$file |cut -d ':' -f2 >\"$(basename \$jobid\_blocks.gene.txt)\"
done
Rscript /home/www/html/iris3/program/sc3.R \$wd\$jobid\_filtered_expression.txt \$jobid \$label_file $delim_label $param_k\n
Rscript /home/www/html/iris3/program/ari_score.R \$label_file \$jobid $delim_label $label_use_sc3
Rscript /home/www/html/iris3/program/cts_gene_list.R \$wd\$jobid\_filtered_expression.txt \$jobid \$wd\$jobid\_cell_label.txt $gene_module_file $delim_gene_module \n
Rscript /home/www/html/iris3/program/cvt_symbol.R \$wd \$wd\$jobid\_filtered_expression.txt\n 
perl /home/www/html/iris3/program/prepare_promoter.pl \$wd $promoter_arg\n
/home/www/html/iris3/program/get_motif.sh \$wd \$motif_min_length \$motif_max_length $motif_program\n
wait
cd \$wd\n
find -name '*' -size 0 -delete\n
Rscript /home/www/html/iris3/program/prepare_bbc.R \$wd $motif_program \$motif_min_length\n
touch bg \n
/home/www/html/iris3/program/get_bbc.sh \$wd\n
Rscript /home/www/html/iris3/program/merge_bbc.R \$wd \$jobid \$motif_min_length\n
cat *CT*.regulon_motif.txt > combine_regulon_motif.txt\n
Rscript /home/www/html/iris3/program/prepare_heatmap.R \$wd \$jobid $label_use_sc3\n
mkdir json
/home/www/html/iris3/program/build_clustergrammar.sh \$wd
mkdir tomtom\n
mkdir logo_tmp\n
mkdir logo\n
/home/www/html/iris3/program/get_logo.sh \$wd
/home/www/html/iris3/program/get_tomtom.sh \$wd
/home/www/html/iris3/program/get_atac_overlap.sh \$wd
zip -R \$wd\$jobid '*.regulon.txt' '*.regulon_gene_name.txt' '*_cell_label.txt' '*_cell_label.txt' '*.blocks' '*_blocks.conds.txt' '*_blocks.gene.txt' '*_filtered_expression.txt' \n

echo 'finish'> done\n  
perl /home/www/html/iris3/program/prepare_email.pl \$jobid\n

");
	} else {
		fwrite($fp,"#!/bin/bash\n 
#No label file
wd=/home/www/html/iris3/data/$jobid/
exp_file=$expfile
label_file=$labelfile
gene_module_file=$gene_module_file
jobid=$jobid
motif_min_length=12
motif_max_length=12
Rscript /home/www/html/iris3/program/genefilter.R \$wd\$exp_file \$jobid $delim $is_gene_filter $is_cell_filter
/home/www/html/iris3/program/qubic/qubic -i \$wd\$jobid\_filtered_expression.txt -d -f $f_arg -c $c_arg -k 18 -o $o_arg
for file in *blocks
do
grep Conds \$file |cut -d ':' -f2 >\"$(basename \$jobid\_blocks.conds.txt)\"
done
for file in *blocks
do
grep Genes \$file |cut -d ':' -f2 >\"$(basename \$jobid\_blocks.gene.txt)\"
done
Rscript /home/www/html/iris3/program/sc3.R \$wd\$jobid\_filtered_expression.txt \$jobid 1 , $param_k\n
label_file=\$jobid\_sc3_label.txt
Rscript /home/www/html/iris3/program/ari_score.R \$label_file \$jobid tab 0
Rscript /home/www/html/iris3/program/cts_gene_list.R \$wd\$jobid\_filtered_expression.txt \$jobid \$wd\$jobid\_cell_label.txt $gene_module_file $delim_gene_module \n
Rscript /home/www/html/iris3/program/cvt_symbol.R \$wd \$wd\$jobid\_filtered_expression.txt\n
perl /home/www/html/iris3/program/prepare_promoter.pl \$wd $promoter_arg\n
/home/www/html/iris3/program/get_motif.sh \$wd \$motif_min_length \$motif_max_length $motif_program\n
wait
cd \$wd\n
find -name '*' -size 0 -delete\n
Rscript /home/www/html/iris3/program/prepare_bbc.R \$wd $motif_program\n
touch bg \n
/home/www/html/iris3/program/get_bbc.sh \$wd\n
Rscript /home/www/html/iris3/program/merge_bbc.R \$wd \$jobid \$motif_length\n
cat *CT*.regulon_motif.txt > combine_regulon_motif.txt\n
Rscript /home/www/html/iris3/program/prepare_heatmap.R \$wd \$jobid 0
mkdir json
/home/www/html/iris3/program/build_clustergrammar.sh \$wd
mkdir tomtom\n
mkdir logo_tmp\n
mkdir logo\n
/home/www/html/iris3/program/get_logo.sh \$wd
/home/www/html/iris3/program/get_tomtom.sh \$wd
/home/www/html/iris3/program/get_atac_overlap.sh \$wd
zip -R \$wd\$jobid '*.regulon.txt' '*.regulon_gene_name.txt' '*_cell_label.txt' '*_cell_label.txt' '*.blocks' '*_blocks.conds.txt' '*_blocks.gene.txt' '*_filtered_expression.txt' \n

perl /home/www/html/iris3/program/prepare_email.pl \$jobid\n
echo 'finish'> done\n 
");}
	fclose($fp);
	session_destroy();
	system("chmod -R 777 $workdir2");
	$fp = fopen("$workdir2/param.txt", 'w+');
	fwrite($fp,"$jobid $workdir $selected_val $c_arg $k_arg $o_arg $f_arg $expfile");
	fclose($fp);
	system("cd $workdir; nohup sh qsub.sh > output.txt &");
	##shell_exec("$workdir/qsub.sh>$workdir/output.txt &");
	#header("Location: results.php?jobid=$jobid");
	$smarty->assign('o_arg',$o_arg);
	header("Location: results.php?jobid=$jobid");
		
		
	}

}else
{
	$smarty->display('submit.tpl');
}



?> 

