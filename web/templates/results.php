<?php
require("config/smarty.php");
require("config/common.php");
require("config/tools.php");
        $jobid = $_GET['jobid'];
	#$nc= $_GET['NCnumber'];
	#$strand =$_GET['strand'];
    #    $ncid=str_replace(".fna", "", $nc);
	$workdir = "./data/$jobid";

$download_flag =$download_url="";
	$myFile = "$workdir/output.txt";
		if (filesize($myFile)){
$fh = fopen($myFile, 'r');
$theData = fread($fh, filesize($myFile));
fclose($fh);
		}

$Download1 = "$workdir/exp/txt/GoolamM111c100k3o200f_log.txt";
$Download2 = "/home/www/html/iris3/program/S_k/Goolam111_S_k.csv";
if (file_exists($Download1)){
	$download_flag = "1";
	$download_url1 = "http://bmbl.sdstate.edu/iris3/data/$jobid/GoolamM111c100k3o200f_log.txt";
	$download_url2 = "http://bmbl.sdstate.edu/iris3/program/S_k/Goolam111_S_k.csv";
}
else {
	$download_url = "0";
	header("Refresh: 10;url='results.php?jobid=$jobid'");
}
$page = $_SERVER['PHP_SELF'];
$smarty->assign('page', $page);
   	$smarty->assign('theData', $theData);
	 $smarty->assign("download_flag", $download_flag);
	 $smarty->assign("download_url1", $download_url1);
	 $smarty->assign("download_url2", $download_url2);
        $smarty->display('results.tpl');

?>
