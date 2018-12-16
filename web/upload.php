<?php
require("config/smarty.php");
require("config/common.php");
require("config/tools.php");

$ds = DIRECTORY_SEPARATOR;  //1
 
$storeFolder = 'uploads';   //2
 
if (!empty($_FILES)) {
     
    $tempFile = $_FILES['file']['tmp_name'];          //3             
      
    $targetPath = dirname( __FILE__ ) . $ds. $storeFolder . $ds;  //4
     
    $targetFile =  $targetPath. $_FILES['file']['name'];  //5
 
    move_uploaded_file($tempFile,$targetFile); //6
     
} 
$page = $_SERVER['PHP_SELF'];
$smarty->assign('page', $page);
   	$smarty->assign('theData', $theData);
	 $smarty->assign("download_flag", $download_flag);
	 $smarty->assign("download_url1", $download_url1);
	 $smarty->assign("download_url2", $download_url2);
     $smarty->display('tutorial.tpl');

?>
