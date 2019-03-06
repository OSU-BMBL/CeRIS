<?php
#http://bmbl.sdstate.edu/iris3/prepare_tomtom.php?jobid=2018122581354&ct=6&bic=3&m=3&db=HOCOMOCO
require_once("config/common.php");
require_once("config/smarty.php");
require_once("lib/spyc.php");
//require_once("lib/hmmer.php");
$jobid = $_GET['jobid'];
$ct=$_GET['ct'];
$bic=$_GET['bic'];
$motif=$_GET['m'];
$db=$_GET['db'];
//$encodedString = json_encode($annotation1);
$done_file="a";
$motif_filename = "/home/www/html/iris3/data/$jobid/logo/ct$ct"."bic$bic"."m$motif".".fsa.meme";
$check_dir = "/home/www/html/iris3/data/$jobid/tomtom/ct$ct"."bic$bic"."m$motif";
#print_r($check_dir);
if (!file_exists($check_dir)){
	
	#print_r ("start running");
	mkdir ("/home/www/html/iris3/data/$jobid/tomtom/ct$ct"."bic$bic"."m$motif");
	mkdir ("/home/www/html/iris3/data/$jobid/tomtom/ct$ct"."bic$bic"."m$motif/HOCOMOCO");
	mkdir ("/home/www/html/iris3/data/$jobid/tomtom/ct$ct"."bic$bic"."m$motif/JASPAR");
	
	$run_hoco = "nohup /home/www/html/iris3/program/meme/bin/tomtom  -no-ssc -oc /home/www/html/iris3/data/$jobid/tomtom/ct$ct"."bic$bic"."m$motif/HOCOMOCO -verbosity 1 -min-overlap 5 -mi 1 -dist pearson -evalue -thresh 10.0 $motif_filename /home/www/html/iris3/program/motif_databases/HUMAN/HOCOMOCOv11_full_HUMAN_mono_meme_format.meme /home/www/html/iris3/program/motif_databases/MOUSE/HOCOMOCOv11_full_MOUSE_mono_meme_format.meme &";
	$run_jas = "nohup /home/www/html/iris3/program/meme/bin/tomtom  -no-ssc -oc /home/www/html/iris3/data/$jobid/tomtom/ct$ct"."bic$bic"."m$motif/JASPAR -verbosity 1 -min-overlap 5 -mi 1 -dist pearson -evalue -thresh 10.0 $motif_filename /home/www/html/iris3/program/motif_databases/JASPAR/JASPAR2018_CORE_non-redundant.meme /home/www/html/iris3/program/motif_databases/JASPAR/JASPAR2018_CORE_vertebrates_non-redundant.meme &";
	header("Refresh: 1;url='prepare_tomtom.php?jobid=$jobid&ct=$ct&bic=$bic&m=$motif&db=$db'");
	system($run_hoco);
	system($run_jas);
	
}   else if (file_exists("/home/www/html/iris3/data/$jobid/tomtom/ct$ct"."bic$bic"."m$motif/$db")){
	$status = "0";
	header("Location: data/$jobid/tomtom/ct$ct"."bic$bic"."m$motif/$db/tomtom.html");
}	else {
	header("Refresh: 3;url='prepare_tomtom.php?jobid=$jobid&ct=$ct&bic=$bic&m=$motif&db=$db'");
}

$smarty->assign('filename',$filename);
$smarty->assign('jobid',$jobid);
$smarty->display('prepare_tomtom.tpl');

?>
