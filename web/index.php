<?php
// include "head.html";
set_time_limit(300);
require("config/common.php");
require("config/smarty.php");

$smarty->caching = true;
$smarty->assign('section', 'Homepage');
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
	$exp_out_dir = "/home/www/html/iris3/data/$jobid/exp/";
#	header("Location: warning.php");
	#system("touch $workdir2/status.txt");
	mkdir($exp_out_dir);
	mkdir("$exp_out_dir/txt/");
	$fp = fopen("$workdir2/qsub.sh", 'w');
	if ($selected_val=="use_example") {
	    fwrite($fp,"#!/bin/bash\n Rscript /home/www/html/iris3/program/Goolam111c100k3o200.R /home/cankun/IRIS3/data_for_test/expression_data/test_yan.csv $c_arg $k_arg $o_arg $f_from $f_to $f_by $exp_out_dir\n/home/matlab/bin/matlab -nodisplay -nojvm < /home/www/html/iris3/program/S_k/main_cluster.m 
");
	} else {
		fwrite($fp,"#!/bin/bash\n Rscript /home/www/html/iris3/program/Goolam111c100k3o200.R $workdir2$expfile $c_arg $k_arg $o_arg $f_from $f_to $f_by $exp_out_dir\n/home/matlab/bin/matlab -nodisplay -nojvm < /home/www/html/iris3/program/S_k/main_cluster.m 
");
	}
	fclose($fp);
	

	system("chmod -R 777 $workdir2");
	#$fp = fopen("$workdir2/param.txt", 'w+');
	#fwrite($fp,"$jobid $workdir $selected_val $c_arg $k_arg $o_arg $f_from $f_to $f_by $expfile");
	#fclose($fp);
	#system("bash $workdir/qsub.sh>$workdir/output.txt");
	shell_exec("$workdir/qsub.sh>$workdir/output.txt &");
	header("Location: results.php?jobid=$jobid");
}else
{
	$smarty->display('home.tpl');
}
?> 

