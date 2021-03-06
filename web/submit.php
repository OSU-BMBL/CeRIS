<?php
// include "head.html";
set_time_limit(3000);
session_start();



require("config/common.php");
require("config/smarty.php");


$smarty->caching = true;
$smarty->assign('section', 'Homepage');
#$_SESSION['labelfile'] = '';
#$_SESSION['gene_module_file'] = '';

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
	file_put_contents("/var/www/html/CeRIS/ip.txt",PHP_EOL .get_client_ip_server(), FILE_APPEND | LOCK_EX);
	//$jobid = date("YmdGis");
	$jobid = $_SESSION['jobid'];
	
	$workdir = "./data/$jobid";
	mkdir($workdir);
	$if_allowSave = $_POST['allowstorage'];
	$is_imputation = $_POST['is_imputation'];
	$is_c = $_POST['is_c'];
	if($is_imputation =="") {
		$is_imputation = '0';
	}
	if($is_c =="1") {
		$is_c = '-C';
	} else {
		$is_c = '';
	}
	
	if($if_allowSave =="") {
		$if_allowSave = '0';
	}
	$email = $_POST['email'];
	$c_arg = '1.0';
	$c_arg = '20';
	$f_arg = '0.5';
	$o_arg = '100';
	$promoter_arg = '1000';
	$param_k = '0';
	$c_arg = $_POST['c_arg'];
	$f_arg = $_POST['f_arg'];
	$o_arg = $_POST['o_arg'];
	$k_arg = $_POST['k_arg'];
	$is_load_exp = $_POST['is_load_exp'];
	$is_load_label = $_POST['is_load_label'];
	$is_load_gene_module = $_POST['is_load_gene_module'];
	$promoter_arg = $_POST['promoter_arg'];
	$enable_sc3_k = $_POST['enable_sc3_k'];
	if($enable_sc3_k == "specify"){
		$param_k = $_POST['param_k'];
		if ($param_k == ""){
			$param_k = '0';
		}
	}
	$species_arg=$_POST['species_arg'];
	#$fp = fopen("$workdir/species.txt", 'w');
	#fwrite($fp,"$species_arg");
	#fclose($fp);
	file_put_contents("$workdir/species.txt", implode(PHP_EOL, $species_arg));
	file_put_contents("$workdir/species.txt", "\n",FILE_APPEND);
	$expfile = $_SESSION['expfile'];
	$labelfile = $_SESSION['labelfile'];
	$gene_module_file = $_SESSION['gene_module_file'];
	/*if ($is_load_exp == '0') {
		$expfile = "";
	}
	if ($is_load_label == '0') {
		$labelfile = "";
	}
	if ($is_load_gene_module == '0') {
		$gene_module_file = "";
	}*/
	$bic_inference = $_POST['bicluster_inference'];
	if( $expfile!='CeRIS_example_expression_matrix.csv' && $labelfile == 'CeRIS_example_label.csv'){
		$labelfile = "";
	}
	if( $expfile!='CeRIS_example_expression_matrix.csv' && $gene_module_file == 'CeRIS_example_gene_module.csv'){
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
	if($expfile=='CeRIS_example_expression_matrix.csv'){
		$fp = fopen("$workdir/upload_type.txt", 'w');
		fwrite($fp,"CellGene\n");
		fclose($fp);
	}
	if($c_arg == '1.0' && $f_arg == '0.5' && $o_arg == '100' && $label_use_sc3 == '1' && $expfile=='CeRIS_example_expression_matrix.csv' && $labelfile == 'CeRIS_example_label.csv'){

		header("Location: results.php?jobid=2019081954006");
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
	} else if($delim==" "){
		$delim = "space";
	} else if($delim==";"){
		$delim = "semicolon";
	} else {
		$delim = ",";
	}
	$delim_label = detectDelimiter("$workdir2/$labelfile");
		if($delim_label=="\t"){
		$delim_label = "tab";
	}
	if($delim_label==" "){
		$delim_label = "space";
	}
	if ($gene_module_file != "") {
	$delim_gene_module = detectDelimiter("$workdir2/$gene_module_file");
	if($delim_gene_module=="\t"){
		$delim_gene_module = "tab";
	}
	if($delim_gene_module==" "){
		$delim_gene_module = "space";
	}
	}
	$fp = fopen("$workdir/info.txt", 'w');
	fwrite($fp,"is_load_exp,$is_load_exp\nk_arg,$k_arg\nf_arg,$f_arg\no_arg,$o_arg\nlabel_use_sc3,$label_use_sc3\nexpfile,$expfile\nlabelfile,$labelfile\ngene_module_file,$gene_module_file\nis_imputation,$is_imputation\nis_c,$is_c\npromoter_arg,$promoter_arg\nif_allowSave,$if_allowSave\nbic_inference,$bic_inference");
	fclose($fp);
	$fp = fopen("$workdir2/qsub.sh", 'w');
	if($if_allowSave != '0'){
    system("cp $workdir2$expfile /var/www/html/CeRIS/storage");
	}

if ($labelfile == ''){
	$labelfile = '1';
	$delim_label = ',';
}


fwrite($fp,"#!/bin/bash\n 
wd=/var/www/html/CeRIS/data/$jobid/
exp_file=$expfile
label_file=$labelfile
gene_module_file=$gene_module_file
jobid=$jobid
motif_min_length=12
motif_max_length=12
#perl /var/www/html/CeRIS/program/prepare_email.pl \$jobid\n
Rscript /var/www/html/CeRIS/program/genefilter.R \$wd\$exp_file \$jobid $delim $is_imputation \$label_file $delim_label $param_k $label_use_sc3
/var/www/html/CeRIS/program/qubic2/qubic -i \$wd\$jobid\_filtered_expression.txt -k $k_arg -o $o_arg -f $f_arg $is_c
for file in *blocks
do
grep Conds \$file |cut -d ':' -f2 >\"$(basename \$jobid\_blocks.conds.txt)\"
done
for file in *blocks
do
grep Genes \$file |cut -d ':' -f2 >\"$(basename \$jobid\_blocks.gene.txt)\"
done
Rscript /var/www/html/CeRIS/program/ari_score.R \$label_file \$jobid $delim_label $label_use_sc3
Rscript /var/www/html/CeRIS/program/cts_gene_list.R \$wd \$jobid $promoter_arg $gene_module_file $delim_gene_module \n
#Rscript /var/www/html/CeRIS/program/cvt_symbol.R \$wd \$wd\$jobid\_filtered_expression.txt \$jobid $promoter_arg\n 
/var/www/html/CeRIS/program/get_motif.sh \$wd \$motif_min_length \$motif_max_length 1
Rscript /var/www/html/CeRIS/program/convert_meme.R \$wd \$motif_min_length
/var/www/html/CeRIS/program/get_motif.sh \$wd \$motif_min_length \$motif_max_length 0
wait
cd \$wd\n
find -name '*' -size 0 -delete\n
Rscript /var/www/html/CeRIS/program/prepare_bbc.R \$jobid \$motif_min_length\n

mkdir tomtom\n
mkdir logo_tmp\n
mkdir logo\n
mkdir regulon_id\n
/var/www/html/CeRIS/program/get_logo.sh \$wd
/var/www/html/CeRIS/program/get_tomtom.sh \$wd
#touch bg \n
#/var/www/html/CeRIS/program/get_bbc.sh \$wd\n
#Rscript /var/www/html/CeRIS/program/merge_bbc.R \$wd \$jobid \$motif_min_length\n
Rscript /var/www/html/CeRIS/program/merge_tomtom.R \$wd \$jobid \$motif_min_length\n
Rscript /var/www/html/CeRIS/program/sort_regulon.R \$wd \$jobid\n
/var/www/html/CeRIS/program/get_atac_overlap.sh \$wd
#cat *CT*.regulon_motif.txt > combine_regulon_motif.txt\n
Rscript /var/www/html/CeRIS/program/prepare_heatmap.R \$wd \$jobid $label_use_sc3\n
Rscript /var/www/html/CeRIS/program/get_alternative_regulon.R \$jobid\n
Rscript /var/www/html/CeRIS/program/generate_rss_scatter.R \$jobid\n
mkdir json
/var/www/html/CeRIS/program/build_clustergrammar.sh \$wd \$jobid $label_use_sc3\n


zip -R \$wd\$jobid '*.regulon_gene_id.txt' '*.regulon_gene_symbol.txt' '*.regulon_rank.txt' '*.regulon_activity_score.txt' '*_cell_label.txt' '*.blocks' '*_blocks.conds.txt' '*_blocks.gene.txt' '*_filtered_expression.txt' '*_gene_id_name.txt' '*_marker_genes.txt' 'cell_type_unique_marker.txt' '*_combine_regulon.txt'\n
perl /var/www/html/CeRIS/program/prepare_email.pl \$jobid\n
echo 'finish'> done\n  
chmod -R 777 .
");

	fclose($fp);
	session_destroy();
	system("chmod -R 777 $workdir2");
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

