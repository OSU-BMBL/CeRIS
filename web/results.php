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
#$info = Spyc::YAMLLoad("$DATAPATH/$jobid/info.yaml");
$status= $info['status'];

$big=intval($info['big']);
$tempnam ="$DATAPATH/$jobid";	
$done_file = "$DATAPATH/$jobid/done";

$regulon_gene_name_file = array();
$regulon_file = array();
if (file_exists("$DATAPATH/$jobid/info.txt")){
$param_file = fopen("$DATAPATH/$jobid/info.txt", "r");
	if ($param_file) {
		while (($line = fgets($param_file)) !== false) {
			$split_line = explode (",", $line);
			if($split_line[0] == "c_arg"){
				$c_arg = $split_line[1];
			} else if($split_line[0] == "f_arg"){
				$f_arg = $split_line[1];
			} else if($split_line[0] == "o_arg"){
				$o_arg = $split_line[1];
			} else if($split_line[0] == "motif_program"){
				if( $split_line[1] == 0) {
					$motif_program = "DMINDA";
				} else{
					$motif_program = "MEME";
				}
			} else if($split_line[0] == "label_use_sc3"){
				if( $split_line[1] == 0 || $split_line[1] == 1) {
					$label_use_sc3 = "SC3";
				} else{
					$label_use_sc3 = "User's label";
				}
			} else if($split_line[0] == "expfile"){
				$expfile_name = $split_line[1];
			} else if($split_line[0] == "labelfile"){
				$labelfile_name = $split_line[1];
			} else if($split_line[0] == "is_filter"){
				if( $split_line[1] == '0') {
					$is_filter = "No";
				} else{
					$is_filter = "Yes";
				}
			} else if($split_line[0] == "if_allowSave"){
				if( $split_line[1] == 0) {
					$if_allowSave = "No";
				} else{
					$if_allowSave = "Yes";
				}
			}
		}

		fclose($param_file);
	} else {
		print_r("Info file not found");
		// error opening the file.
	} 
}


if (file_exists($done_file)){
foreach (glob("$DATAPATH/$jobid/*_bic.regulon_gene_name.txt") as $file) {
	
  $regulon_gene_name_file[] = $file;
}

foreach (glob("$DATAPATH/$jobid/*_bic.regulon.txt") as $file) {
	
  $regulon_id_file[] = $file;
}

foreach (glob("$DATAPATH/$jobid/*_bic.regulon_motif.txt") as $file) {
	
  $regulon_motif_file[] = $file;
}

$count_ct = range(1,count($regulon_gene_name_file));
$info_file = fopen("$DATAPATH/$jobid/$jobid"."_info.txt", "r");
$count_regulon_in_ct = array(); 
if ($info_file) {
    while (($line = fgets($info_file)) !== false) {
        $split_line = explode (",", $line);
		if($split_line[0] == "filter_num"){
			$filter_num = $split_line[1];
		} else if($split_line[0] == "total_num"){
			$total_num = $split_line[1];
		} else if($split_line[0] == "filter_num"){
			$filter_num = $split_line[1];
		} else if($split_line[0] == "filter_rate"){
			$filter_rate = $split_line[1];
		} else if($split_line[0] == "total_label"){
			$total_label = $split_line[1];
		} else if($split_line[0] == "total_bic"){
			$total_bic = $split_line[1];
		} else if($split_line[0] == "total_ct"){
			$total_ct = $split_line[1];
		} else if($split_line[0] == "total_regulon"){
			$total_regulon = $split_line[1];
		} else if($split_line[0] == "is_evaluation"){
			$is_evaluation = $split_line[1];
		} else if($split_line[0] == "species"){
			$species = $split_line[1];
		}
    }

    fclose($info_file);
} else {
	print_r("Info file not found");
    // error opening the file.
} 



if (file_exists("$DATAPATH/$jobid/$jobid"."_sankey.txt")){
	$sankey_file = fopen("$DATAPATH/$jobid/$jobid"."_sankey.txt", "r");
	if ($sankey_file) {
	$sankey_nodes = $sankey_src = $sankey_target = $sankey_value = array(); 
    while (($line = fgets($sankey_file)) !== false) {
        $split_line = explode (",", $line);
		$split_line[1] = preg_replace( "/\r|\n/", "", $split_line[1] );
		if($split_line[0] == "src"){
			array_push($sankey_src,$split_line[1]);
		} else if($split_line[0] == "target"){
			array_push($sankey_target,$split_line[1]);
		} else if($split_line[0] == "value"){
			array_push($sankey_value,$split_line[1]);
		} else if($split_line[0] == "nodes"){
			array_push($sankey_nodes,$split_line[1]);
		}
    }
    fclose($sankey_file);
	$sankey_src = json_encode($sankey_src);
	$sankey_target = json_encode($sankey_target);
	$sankey_value = json_encode($sankey_value);
	$sankey_nodes = json_encode($sankey_nodes);
} else {
	print_r("Info file not found");
    // error opening the file.
} 
}


$silh_file = fopen("$DATAPATH/$jobid/$jobid"."_silh.txt", "r");
if ($silh_file) {
	$silh_trace = $silh_x = $silh_y  = $line_cell = $line_result = array(); 
	
	for ($i=1;$i <= count($regulon_gene_name_file);$i++){
		$silh_file = fopen("$DATAPATH/$jobid/$jobid"."_silh.txt", "r");
		$line_cell = $line_result = array(); 
		while (($line = fgets($silh_file)) !== false) {
        $split_line = explode (",", $line);
		$split_line[2] = preg_replace( "/\r|\n/", "", $split_line[2] );
			if($i == (int)$split_line[0]){
				
				array_push($line_cell, $split_line[1]);
				array_push($line_result, $split_line[2]);
			}
		}
		$silh_x[$i] = $line_cell;
		$silh_y[$i] = $line_result;
		array_push($silh_trace,$i);
	}
    fclose($silh_file);
	#$silh_trace = json_encode($silh_trace);
	#$silh_x = json_encode($silh_x);
	#$silh_y = json_encode($silh_y);
} else {
	print_r("Info file not found");
    // error opening the file.
} 
foreach ($regulon_gene_name_file as $key=>$this_regulon_gene_name_file){
	
	$status = "1";
	$fp = fopen("$this_regulon_gene_name_file", 'r');
	 if ($fp){
	 while (($line = fgetcsv($fp, 0, "\t")) !== FALSE) if ($line) {
		 $regulon_result[$key][] = array_map('trim',$line);
		 
	 }
	 //$count_regulon_in_ct[$key] = count($regulon_result[$key])
	 
	 array_push($count_regulon_in_ct,count($regulon_result[$key]));
	 } else{
		 die("Unable to open file");
	 }
	fclose($fp);
	
	}
	
foreach ($regulon_id_file as $key=>$this_regulon_id_file){
	
	$status = "1";

	$fp = fopen("$this_regulon_id_file", 'r');
	if ($fp){
	while (($line = fgetcsv($fp, 0, "\t")) !== FALSE) 
		if ($line) {$regulon_id_result[$key][] = array_map('trim',$line);}
	} else{
		die("Unable to open file");
	}
	fclose($fp);
	}
	
foreach ($regulon_motif_file as $key=>$this_regulon_motif_file){
	
	$status = "1";

	$fp = fopen("$this_regulon_motif_file", 'r');
	if ($fp){
	while (($line = fgetcsv($fp, 0, "\t")) !== FALSE) 
		if ($line) {$regulon_motif_result[$key][] = array_map('trim',$line);}
	} else{
		die("Unable to open file");
	}
	fclose($fp);
	}

}else if (!file_exists($tempnam)) {
	$status= "404";
}else {
	$status = "0";
	header("Refresh: 15;url='results.php?jobid=$jobid'");
}
 /*
foreach ($regulon_motif_result as $a1){
	foreach ($a1 as $a2) {
		foreach ($a2 as $a3){
			print_r(explode(',',$a3));
		}
		
	}
	
}*/


//print_r($regulon_result);
//$encodedString = json_encode($annotation1);
 
//Save the JSON string to a text file.
//file_put_contents('json_array.txt', $encodedString);
$_SESSION[$jobid."ann"]=$annotation1;
$smarty->assign('filter_num',$filter_num);
$smarty->assign('total_num',$total_num);
$smarty->assign('filter_rate',$filter_rate);
$smarty->assign('total_label',$total_label);
$smarty->assign('total_bic',$total_bic);
$smarty->assign('total_ct',$total_ct);
$smarty->assign('total_regulon',$total_regulon);
$smarty->assign('count_ct',$count_ct);
$smarty->assign('species',$species);
$smarty->assign('status',$status);
$smarty->assign('jobid',$jobid);
$smarty->assign('count_regulon_in_ct',$count_regulon_in_ct);
$smarty->assign('regulon_result',$regulon_result);
$smarty->assign('regulon_id_result',$regulon_id_result);
$smarty->assign('regulon_motif_result',$regulon_motif_result);
$smarty->assign('big',$big);
$smarty->assign('c_arg',$c_arg);
$smarty->assign('f_arg',$f_arg);
$smarty->assign('o_arg',$o_arg);
$smarty->assign('motif_program',$motif_program);
$smarty->assign('label_use_sc3',$label_use_sc3);
$smarty->assign('expfile_name',$expfile_name);
$smarty->assign('labelfile_name',$labelfile_name);
$smarty->assign('is_filter',$is_filter);
$smarty->assign('if_allowSave',$if_allowSave);
$smarty->assign('annotation', $annotation1);
$smarty->assign('LINKPATH', $LINKPATH);
$smarty->assign('silh_trace',$silh_trace);
//print_r($silh_trace);
$smarty->assign('silh_y',$silh_y);
$smarty->assign('silh_x',$silh_x);
$smarty->assign('sankey_src',$sankey_src);
$smarty->assign('sankey_target',$sankey_target);
$smarty->assign('sankey_value', $sankey_value);
$smarty->assign('sankey_nodes', $sankey_nodes);
$smarty->display('results.tpl');

?>
