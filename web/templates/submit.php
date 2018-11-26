<?php
require("config/smarty.php");
require("config/common.php");
require("config/tools.php");
if (isset($_POST['submit']))
{
$email = $_POST["id_email"];	
	$jobid = date("YmdGis");
	$workdir = "./data/$jobid";
	mkdir($workdir);
	$selected_val = $_POST['radio'];
	
	$c_arg = $_POST['c_arg'];
	$k_arg = $_POST['k_arg'];
	$o_arg = $_POST['o_arg'];
	$f_from = $_POST['f_from'];
	$f_to = $_POST['f_to'];
	$f_by = $_POST['f_by'];
	$expfile = $_FILES["expfile"]["name"];
	#$pttfile = $_FILES["pttfile"]["name"];
	#$gfffile = $_FILES["gfffile"]["name"];
	
	$expfileTmpLoc = $_FILES["expfile"]["tmp_name"];
	
	$fp = fopen("$workdir/info.txt", 'w');
        fwrite($fp,"$jobid"."$rnaid\t$email");
        fclose($fp);
	$workdir2 = "./data/$jobid/";
	mkdir($workdir2);
	system("mv $expfileTmpLoc $workdir2$expfile ");
	$exp_out_dir = "./data/$jobid/exp/";
#	header("Location: warning.php");
	system("touch $workdir2/status.txt");
	mkdir($exp_out_dir);
	$fp = fopen("$workdir2/qsub.sh", 'w');
	if ($selected_val=="use_example") {
	    fwrite($fp,"#!/bin/bash\n Rscript /home/www/html/iris3/program/Goolam111c100k3o200.R /home/cankun/IRIS3/data_for_test/expression_data/test_yan.csv $c_arg $k_arg $o_arg $f_from $f_to $f_by $exp_out_dir");
	} else {
		fwrite($fp,"#!/bin/bash\n Rscript /home/www/html/iris3/program/Goolam111c100k3o200.R $workdir2$expfile $c_arg $k_arg $o_arg $f_from $f_to $f_by $exp_out_dir");
	}
	fclose($fp);
	system("chmod -R 777 $workdir2");
	system("cd $workdir2");
	system("bash qsub.sh ");
	$fp = fopen("$workdir2/status.txt", 'w');
	fwrite($fp,"Download the feature extraction output");
	fclose($fp);
	
	system("chmod -R 777 $workdir2");
	#system("Rscript /home/www/html/GeneQC/GeneQC_files/data/modeling_script.R /home/www/html/GeneQC/data/$jobid/$jobid.txt $jobid");
	$fp = fopen("$workdir2/param.txt", 'w+');
	fwrite($fp,"$jobid $workdir $selected_val $c_arg $k_arg $o_arg $f_from $f_to $f_by $expfile");
	fclose($fp);
	header("Location: results.php?jobid=$jobid");
}else
{
	$smarty->display('submit.tpl');
}
?>
