<?php
require("config/smarty.php");
require("config/common.php");
require("config/tools.php");

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

 $json=$_POST['filename'];

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

 if (!file_exists($workdir)) {
     mkdir($workdir);
}
 $temp_file = $_FILES['file']['tmp_name'];
 
 $csv= file_get_contents($temp_file);



 $delim = detectDelimiter($temp_file);
$array = file($temp_file);
#$new_array = array();
#foreach ($array as $line) {
#    // explode the line on tab. Note double quotes around \t are mandatory
#    $line_array = explode("$delim", $line);
#    // set first element to the new array
#    #$new_array[] = $line_array[0];
#	$new_array[] = array_map('trim',$line_array);
#}

 $fp = fopen("$temp_file", 'r');
	if ($fp){
	$idx = 0;
		while (($line = fgetcsv($fp, 0, "$delim")) !== FALSE){
			if ($line) {
				if ($idx == 0) {
					$remove_first =array_shift($line);
					$new_array['columns'][] = $line;
				}
				else {
					$new_array['index'][] = array_map('trim',$line)[0];
					$remove_first =array_shift($line);
					$new_array['data'][] = array_map('trim',$line);
				}
			}
			$idx = $idx + 1;
			if ($idx == 10){
				break;
			}
		}

	} else{
		die("Unable to open file");
	}
fclose($fp);
  $fp = fopen("$temp_file", 'r');
	if ($fp){
 	$linecount = -2;
	while(!feof($fp)){
	  $line = fgets($fp);
	  $linecount++;
	}
	}
	$new_array['gene_num'][] = $linecount;
	fclose($fp);
 #$response = json_encode($array);
 $filetype=$_POST['filetype'];
 $_SESSION['filetype'] = $filetype;

 if ($filetype == "dropzone_exp"){
	$expfile = $_FILES['file']['name'];
	$expfile = str_replace(" ", "_", $expfile);
	$expfile = str_replace(array( '(', ')' ), '_', $expfile);
	$_SESSION['expfile'] = $expfile;
	$location = $workdir.$expfile;
	move_uploaded_file($temp_file, $location);
 } else if ($filetype == "dropzone_label"){
	$labelfile = $_FILES['file']['name'];
	$labelfile = str_replace(" ", "_", $labelfile);
	$labelfile = str_replace(array( '(', ')' ), '_', $labelfile);
	$location = $workdir.$labelfile;
	$_SESSION['labelfile'] = $labelfile;
	move_uploaded_file($temp_file, $location);
 } else if ($filetype == "dropzone_gene_module"){
	 $gene_module_file = $_FILES['file']['name'];
	 $gene_module_file = str_replace(" ", "_", $gene_module_file);
	 $gene_module_file = str_replace(array( '(', ')' ), '_', $gene_module_file);
	 $location = $workdir.$gene_module_file;
	 $_SESSION['gene_module_file'] = $gene_module_file;
	 move_uploaded_file($temp_file, $location);
 }else {
	 $_SESSION['expfile'] = "test";
 }

#$response=$new_array;
 $response = array_slice($new_array, 0, 5);
 echo json_encode($response); 
  
}else if ($json !=""){
	$example= $_POST['filename'];
	session_start();
    $jobid = $_SESSION['jobid'];
	if ($jobid == "") {
	$jobid = date("YmdGis");
    }else {}
	$_SESSION['jobid'] = $jobid;
	$workdir = "./data/$jobid/";
	 if (!file_exists($workdir)) {
     mkdir($workdir);
	}
	system("cp ./storage/iris3_example_expression_matrix.csv $workdir");
	system("cp ./storage/iris3_example_expression_label.csv $workdir");
	#system("cp ./storage/iris3_example_gene_module.csv $workdir");
	$expfile = 'iris3_example_expression_matrix.csv';
	$_SESSION['expfile'] = $expfile;
	$labelfile = 'iris3_example_expression_label.csv';
	$_SESSION['labelfile'] = $labelfile;
	#$gene_module_file = 'iris3_example_gene_module.csv';
	#$_SESSION['gene_module_file'] = $gene_module_file;

	
}
$page = $_SERVER['PHP_SELF'];
$smarty->assign('jobid', $jobid);
$smarty->assign('expfile', $expfile);
$smarty->assign('labelfile', $labelfile);
$smarty->assign('page', $page);
$smarty->assign('res', $response);

die();
?>
