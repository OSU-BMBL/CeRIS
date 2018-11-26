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


function prepare_prediction($workdir,$info)
{  $BASE=$info['BASE'];
    mkdir($workdir);
    $nc=$workdir."/";
      $tempfnaname = $nc.$info['jobid'];
     $fp = fopen($tempfnaname."tg", 'w');
     fwrite($fp, $info['input']); fclose($fp);
     unset($info["input"]);
      if(preg_match("/Jobid:\d*$/",$info['bkgname']))
        {
        $arr=explode(":", $info['bkgname']);
           $jobid=chop($arr[3]);
           $tempnam ="$BASE/data/annotation/$jobid/$jobid";	
           $fa = fopen("$tempfnaname"."bkg", 'w');
          fwrite($fa, "".file_get_contents($tempnam)); 
          fclose($fa);
           unset($info["bkgname"]);
        
       }
       else
       {
        $fp = fopen("$tempfnaname"."bkg", 'w');
     fwrite($fp, $info['bkgname']); fclose($fp);
     unset($info["bkgname"]);
     }
    
     
     $fp = fopen("$workdir/info.yaml", 'w');
     fwrite($fp, Spyc::YAMLDump($info));
     fclose($fp);
      system("chmod 777 -R $workdir");
     return $workdir;
}



function annotate_prediction($workdir) {  
	$info = Spyc::YAMLLoad("$workdir/info.yaml");	    
    $jobid= basename("$workdir");
    $BASE =$info['BASE'];
	$min=$info['minin'];
	$max=$info['maxin'];
	$num=$info['numout'];
	
	if(intval($num)>80){
		$num=80;
	}
	$ty=$info['style'];
	$bf=$info['bf'];
	$bn=$info['bn'];
	$st=$info['st'];
	$sn=$info['sn'];
    $tempnam ="$BASE/data/annotation/$jobid/$jobid";
    $work="$BASE/data/annotation/$jobid/";
	$check=file_get_contents($tempnam."tg");
	if(intval($info['big'])==1)	{ 
		$chars=explode(">",$check);
		$pnum=count($chars);  
		if ($pnum>400){        
			$num=1;
			for($j=1;$j<=10;$j++){ 
				$result="";
				$mmend=$pnum/10;
				if($mmend>50) $mmend=50;
				for($i=1;$i<=$mmend;$i++){
					$rs=rand(0,$pnum-1);
					$result=$result.">";
					$result=$result.$chars[$rs];
				}
				// print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!".$result);
				$fp = fopen($tempnam."$j", 'w');
				 fwrite($fp, $result);
				 fclose($fp);     
			}
		}
  
	}else{
		$fp = fopen($tempnam."1", 'w');
		fwrite($fp, $check);
		fclose($fp);
		touch($tempnam."2");
		touch($tempnam."3");
		touch($tempnam."4");
		touch($tempnam."5");
		touch($tempnam."6");
		touch($tempnam."7");
		touch($tempnam."8");
		touch($tempnam."9");
		touch($tempnam."10");
	}
	unset($check);
	unset($result);   
    $Rint=2;   
    if($num>10){
        $bn=$num/2;
    }
	
    if((($max-$min+1)/2)>4){    
		$Rint= ceil(($max-$min+1)/4);        
    }
	
    if($bf=="Y"){
		$option="-L ".$min." -U ".$max." -o ".$num." -R $Rint -F -n $bn $sn $st";
	}else{
		$option="-L ".$min." -U ".$max." -o ".$num." -R $Rint -n $bn $sn $st";
	}
	
    $ert=file_get_contents($tempnam."bkg")."asd";
    $asd=strlen($ert);
    if($asd<10){	
		$cmd="#!/usr/bin/env sh\ncd $work\n  perl $BASE/program/BBR.pl 1 $jobid $option >$work/report";
	}else {	
		$cmd="#!/usr/bin/env sh\ncd $work\n  perl $BASE/program/BBR.pl 2 $jobid ".$jobid."bkg $option > $work/report"; 
	}       
	system($cmd);
	system("chmod 777 -R $work");
	if(file_exists($tempnam.".motifinfo")){ 
		system("$BASE/lib/zx.pl $tempnam.motifinfo"); 
		system("$BASE/lib/zx2.pl $tempnam $jobid $BASE");                       
	} 
}



if (isset($_POST['submit']))
{
	$email = $_POST["id_email"];	
	$jobid = date("YmdGis");
	$workdir = "./data/$jobid";
	mkdir($workdir);
	$if_allowSave = isset($_POST['allowstorage']);
	$email = $_POST['email'];
	$c_arg = $_POST['c_arg'];
	$k_arg = $_POST['k_arg'];
	$o_arg = $_POST['o_arg'];
	$f_from = $_POST['f_from'];
	$f_to = $_POST['f_to'];
	$f_by = $_POST['f_by'];
	$expfile = $_FILES["expfile"]["name"];
	$labelfile = $_FILES["labelfile"]["name"];
	#$gfffile = $_FILES["gfffile"]["name"];
	
	$expfileTmpLoc = $_FILES["expfile"]["tmp_name"];
	$labelfileTmpLoc = $_FILES["labelfile"]["tmp_name"];
	system("touch $workdir/email.txt");
	system("chmod 777 $workdir/email.txt");
	$fp = fopen("$workdir/email.txt", 'w');
	if($email == ""){
		$email == "flykun0620@gmail.com";
	}
    fwrite($fp,"$email");
	
    fclose($fp);
	$fp = fopen("$workdir/info.txt", 'w');
        fwrite($fp,"$jobid"."$rnaid\t$email");
        fclose($fp);
	$workdir2 = "./data/$jobid/";
	
	#$delim = detectDelimiter($expfile);
	system("mv $expfileTmpLoc $workdir2$expfile ");
	system("mv $labelfileTmpLoc $workdir2$labelfile ");
	$exp_out_dir = "/home/www/html/iris3/data/$jobid/exp/";
#	header("Location: warning.php");
	#system("touch $workdir2/status.txt");
	#mkdir($exp_out_dir);
	#mkdir("$exp_out_dir/txt/");
	
	$detect_exp = fopen("$workdir2/$expfile", 'r');
	$delim = detectDelimiter($detect_exp);
	fclose($detect_exp);
	$fp = fopen("$workdir2/qsub.sh", 'w');
	if($if_allowSave){
system("cp $workdir2$expfile /home/www/html/iris3/storage");
}

	if ($labelfile){
fwrite($fp,"#!/bin/bash\n 
#labelFile 
wd=/home/www/html/iris3/data/$jobid/
exp_file=$expfile
label_file=$labelfile
jobid=$jobid
Rscript /home/www/html/iris3/program/genefilter.R \$wd\$exp_file \$jobid ,
/home/www/html/iris3/program/qubic/qubic -i \$wd\$jobid\_filtered_expression.txt -d -f 0.5 -c 1 -k 18 -o 100
for file in *blocks
do
grep Conds \$file |cut -d ':' -f2 >\"$(basename \$jobid\_blocks.conds.txt)\"
done
for file in *blocks
do
grep Genes \$file |cut -d ':' -f2 >\"$(basename \$jobid\_blocks.gene.txt)\"
done
Rscript /home/www/html/iris3/program/ari_score.R \$label_file \$jobid 3
Rscript /home/www/html/iris3/program/cts_gene_list.R \$wd\$jobid\_filtered_expression.txt \$jobid \$wd\$jobid\_cell_label.txt\n
Rscript /home/www/html/iris3/program/cvt_symbol.R \$wd\n
perl /home/www/html/iris3/program/prepare_promoter.pl \$wd\n
/home/www/html/iris3/program/get_motif.sh \$wd\n
cd \$wd\n
Rscript /home/www/html/iris3/program/prepare_bbc.R \$wd\n
touch bg \n
/home/www/html/iris3/program/get_bbc.sh \$wd\n
Rscript /home/www/html/iris3/program/merge_bbc.R \$wd\n
touch done\n 
perl /home/www/html/iris3/program/prepare_email.pl \$jobid\n

");
	} else {
		fwrite($fp,"#!/bin/bash\n 
#No label
wd=/home/www/html/iris3/data/$jobid/
exp_file=$expfile
label_file=$labelfile
jobid=$jobid
Rscript /home/www/html/iris3/program/genefilter.R \$wd\$exp_file \$jobid ,
/home/www/html/iris3/program/qubic/qubic -i \$wd\$jobid\_filtered_expression.txt -d -f 0.5 -c 1 -k 18 -o 100
for file in *blocks
do
grep Conds \$file |cut -d ':' -f2 >\"$(basename \$jobid\_blocks.conds.txt)\"
done
for file in *blocks
do
grep Genes \$file |cut -d ':' -f2 >\"$(basename \$jobid\_blocks.gene.txt)\"
done
Rscript /home/www/html/iris3/program/ari_score.R \$label_file \$jobid 3
Rscript /home/www/html/iris3/program/cts_gene_list.R \$wd\$jobid\_filtered_expression.txt \$jobid \$wd\$jobid\_cell_label.txt\n
Rscript /home/www/html/iris3/program/cvt_symbol.R \$wd\n
perl /home/www/html/iris3/program/prepare_promoter.pl \$wd\n
/home/www/html/iris3/program/get_motif.sh \$wd\n
cd \$wd\n
Rscript /home/www/html/iris3/program/prepare_bbc.R \$wd\n
touch bg \n
/home/www/html/iris3/program/get_bbc.sh \$wd\n
Rscript /home/www/html/iris3/program/merge_bbc.R \$wd\n
touch done\n 
perl /home/www/html/iris3/program/prepare_email.pl \$jobid\n
");}
	fclose($fp);
	
	system("chmod -R 777 $workdir2");
	#$fp = fopen("$workdir2/param.txt", 'w+');
	#fwrite($fp,"$jobid $workdir $selected_val $c_arg $k_arg $o_arg $f_from $f_to $f_by $expfile");
	#fclose($fp);
	system("cd $workdir; nohup sh qsub.sh > output.txt &");
	#shell_exec("$workdir/qsub.sh>$workdir/output.txt &");
	#header("Location: results.php?jobid=$jobid");
	header("Location: results.php?jobid=$jobid");
}else
{
	$smarty->display('submit.tpl');
}



?> 

