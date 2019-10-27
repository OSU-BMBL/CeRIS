<?php
	$id = $_GET['id'];
	$jobid = $_GET['jobid'];
	$wd = "/var/www/html/CeRIS/data/$jobid/";
	system("cd $wd; nohup Rscript /var/www/html/CeRIS/program/plot_regulon.R $wd $id $jobid &");
	$response_array['status'] = 'success';  
	echo json_encode($response_array);
	#print_r($json);
	
?>
