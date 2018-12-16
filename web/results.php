<?php
set_time_limit(300);
require_once("config/common.php");
require_once("config/smarty.php");
require_once("lib/spyc.php");
//require_once("lib/hmmer.php");
$jobid=$_GET['jobid'];

$log1="";
$log2="";
$log="";
$status="";
session_start();
#$info = Spyc::YAMLLoad("$DATAPATH/$jobid/info.yaml");
$status= $info['status'];

$big=intval($info['big']);
$tempnam ="$DATAPATH/$jobid";	
$done_file = "$DATAPATH/$jobid/done";

if (file_exists($done_file)){
	$status = "1";
	$fp = fopen("$DATAPATH/$jobid/$jobid"."_CT_1_bic.regulon_genename.txt", 'r');
 if ($fp){
 while (($line = fgetcsv($fp, 0, "\t")) !== FALSE) if ($line) {$regulon_result[] = array_map('trim',$line);}
 } else{
	 die("Unable to open file");
 }
fclose($fp);
$i=0;
$num=0;
 $fp = fopen("$DATAPATH/$jobid/$jobid"."_CT_1_bic.complex.regulon.txt", 'r');
 if ($fp){
 while (($line = fgetcsv($fp, 0, "\t")) !== FALSE) 
	 if ($line){

 $line1 = $line;
foreach ($line as $key => $value) {
    if (is_numeric($value) !== false) {
		$cr_motif[$num][$i] = $value;
        unset($line[$key]);
		$i++;
    }
	
}
$i=0;
$num++;
$cr_gene[] = $line;
}
 } else{
	 die("Unable to open file");
 }
fclose($fp);
}
else {
	$status = "0";
	header("Refresh: 15;url='results.php?jobid=$jobid'");
}




//$encodedString = json_encode($annotation1);
 
//Save the JSON string to a text file.
//file_put_contents('json_array.txt', $encodedString);
$_SESSION[$jobid."ann"]=$annotation1;
$smarty->assign('sy',$sy);
$smarty->assign('status',$status);
$smarty->assign('jobid',$jobid);
$smarty->assign('regulon_result',$regulon_result);
$smarty->assign('cr_gene',$cr_gene);
$smarty->assign('cr_motif',$cr_motif);
$smarty->assign('big',$big);
$smarty->assign('annotation', $annotation1);
$smarty->assign('LINKPATH', $LINKPATH);
$smarty->display('results.tpl');

?>
