<?php
// include "head.html";
set_time_limit(300);
require("config/common.php");
require("config/smarty.php");

$smarty->caching = true;
$smarty->assign('section', 'Homepage');
if (isset($_POST['submit']))
{
$jobid=$_POST['jobid'];

	header("Location: results.php?jobid=$jobid");
}else
{
	$smarty->display('home.tpl');
}
?> 

