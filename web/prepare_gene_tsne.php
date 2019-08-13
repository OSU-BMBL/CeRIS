<?php
	$id = $_GET['id'];
	$jobid = $_GET['jobid'];
	$wd = "/var/www/html/iris3/data/$jobid/";
	system("cd $wd; nohup Rscript /var/www/html/iris3/program/plot_gene_tsne.R $wd $id &");
	#echo "<table id='$table_content_id' border='1'>
	#<tr>
	#<th>$jobid</th>
	#<th>$regulon_id</th>
	#<th>$species </th>
	#</tr></table>";
	#$db_contents=file_get_contents($db_file);
	$response_array['status'] = 'success';  
	echo json_encode($response_array);
	#print_r($json);
	
?>
