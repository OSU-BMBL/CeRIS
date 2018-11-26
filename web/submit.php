<?php
// include "head.html";
set_time_limit(300);
require("config/common.php");
require("config/smarty.php");

$smarty->caching = true;
$smarty->assign('section', 'Homepage');

function detectDelimiter($fh)
{
    $delimiters = ["\t", ";", "|", ",", " "];
    $data_1 = null; $data_2 = null;
    $delimiter = $delimiters[0];
    foreach($delimiters as $d) {
        $data_1 = fgetcsv($fh, 4096, $d);
        if(sizeof($data_1) > sizeof($data_2)) {
            $delimiter = sizeof($data_1) > sizeof($data_2) ? $d : $delimiter;
            $data_2 = $data_1;
        }
        rewind($fh);
    }

    return $delimiter;
}
if (isset($_POST['submit']))
{
	$email = $_POST["id_email"];	
	$jobid = date("YmdGis");
	$workdir = "./data/$jobid";
	mkdir($workdir);
	$if_allowSave = isset($_POST['allowstorage']);
	
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
	
	#$delim = detectDelimiter($expfile);
	system("mv $expfileTmpLoc $workdir2$expfile ");
	$exp_out_dir = "/home/www/html/iris3/data/$jobid/exp/";
#	header("Location: warning.php");
	#system("touch $workdir2/status.txt");
	mkdir($exp_out_dir);
	mkdir("$exp_out_dir/txt/");
	
	$detect_exp = fopen("$workdir2/$expfile", 'r');
	$delim = detectDelimiter($detect_exp);
	fclose($detect_exp);
	
	$fp = fopen("$workdir2/qsub.sh", 'w');
	if ($if_allowSave){
	    fwrite($fp,"#!/bin/bash\n  allow: $delim;\n $if_allowSave;");
	} else {
		fwrite($fp,"#!/bin/bash\n not allow: $delim;\n $if_allowSave;");
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
	$smarty->display('submit.tpl');
}



?> 

