<?php
require("config/smarty.php");
require("config/common.php");
require("config/tools.php");


function detectDelimiter($fh)
{
    $delimiters = ["\\t", ";", "|", ",", " "];
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
$json=$_POST['filename'];
$fp = fopen("/home/www/html/iris3/data/2018122084151/upload_file_info.txt", 'w');
fwrite($fp,"$json");
fclose($fp);
if(!empty($_FILES))
{
 session_start();
 $jobid = $_SESSION['jobid'];
 if ($jobid == "") {
 $jobid = date("YmdGis");
 }else {
	
 }
 $_SESSION['jobid'] = $jobid;
 $workdir = "./data/$jobid/";
 mkdir($workdir);
 $temp_file = $_FILES['file']['tmp_name'];
 $location = $workdir.$_FILES['file']['name'];
 $csv= file_get_contents($temp_file);
 $detect_exp = fopen("$temp_file", 'r');
 $delim = detectDelimiter($detect_exp);
 fclose($detect_exp);
 move_uploaded_file($temp_file, $location);

 $array = array_map("str_getcsv",$delimiter=$delim, explode("\n", $csv));
 $response = json_encode($array);
 $filetype=$_POST['filetype'];
 $_SESSION['filetype'] = $filetype;

 if ($filetype == "dropzone_exp"){
	 $expfile = $_FILES['file']['name'];
	 $_SESSION['expfile'] = $expfile;
 } else if ($filetype == "dropzone_label"){
	 $labelfile = $_FILES['file']['name'];
	 $_SESSION['labelfile'] = $labelfile;
 } else {
	 $_SESSION['expfile'] = "test";
 }

 //echo $_POST[json_encode($response)]; 
  
}else if ($json !=""){
	$example= $_POST['filename'];
	session_start();
    $jobid = $_SESSION['jobid'];
	if ($jobid == "") {
	$jobid = date("YmdGis");
    }else {}
	$_SESSION['jobid'] = $jobid;
	$workdir = "./data/$jobid/";
	mkdir($workdir);
	system("cp ./storage/iris3_example_expression_matrix.csv $workdir");
	system("cp ./storage/iris3_example_expression_label.csv $workdir");
	$expfile = 'iris3_example_expression_matrix.csv';
	$_SESSION['expfile'] = $expfile;
	$labelfile = 'iris3_example_expression_label.csv';
	$_SESSION['labelfile'] = $labelfile;
	
}
$page = $_SERVER['PHP_SELF'];
$smarty->assign('jobid', $jobid);
$smarty->assign('expfile', $expfile);
$smarty->assign('labelfile', $labelfile);
$smarty->assign('page', $page);
$smarty->assign('res', $response);

die();
?>
