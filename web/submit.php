<?php
// include "head.html";
set_time_limit(300);
require("config/common.php");
require("config/smarty.php");

$smarty->caching = true;
$smarty->assign('section', 'Homepage');

/*function detectDelimiter($fh)
{
    $delimiters = [",", ";", "|", "tab", " "];
    $data_1 = null; $data_2 = null;
    $delimiter = $delimiters[0];
    foreach($delimiters as $d) {
        $data_1 = fgetcsv($fh, 65536, $d);
        if(sizeof($data_1) > sizeof($data_2)) {
            $delimiter = sizeof($data_1) > sizeof($data_2) ? $d : $delimiter;
			$size = sizeof($data_1);
			$writetmp = "$d\t$size";
			$myfile = file_put_contents('/home/www/html/iris3/data/20181219134153/email.txt', $writetmp.PHP_EOL , FILE_APPEND | LOCK_EX);

            $data_2 = $data_1;
        }
        rewind($fh);
    }
    return $delimiter;
}*/

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
if (isset($_POST['submit']))
{
	session_start();
	$email = $_POST["id_email"];	
	//$jobid = date("YmdGis");
	$jobid = $_SESSION['jobid'];
	$workdir = "./data/$jobid";
	mkdir($workdir);
	$if_allowSave = $_POST['allowstorage'];
	$email = $_POST['email'];
	$c_arg = $_POST['c_arg'];
	$f_arg = $_POST['f_arg'];
	$o_arg = $_POST['o_arg'];
	$expfile = $_SESSION['expfile'];
	$labelfile = $_SESSION['labelfile'];
	
	system("touch $workdir/email.txt");
	system("chmod 777 $workdir/email.txt");
	$fp = fopen("$workdir/email.txt", 'w');
	if($email == ""){
		$email == "flykun0620@gmail.com";
	}
    fwrite($fp,"$email");
	
    fclose($fp);
	//$fp = fopen("$workdir/info.txt", 'w');
    //    fwrite($fp,"$jobid"."$rnaid\t$email");
    //    fclose($fp);
	$workdir2 = "./data/$jobid/";
	
	#$delim = detectDelimiter($expfile);
#	header("Location: warning.php");
	#system("touch $workdir2/status.txt");
	
	$delim = detectDelimiter("$workdir2/$expfile");
	if($delim=="\t"){
		$delim = "tab";
	}
	$delim_label = detectDelimiter("$workdir2/$labelfile");
		if($delim_label=="\t"){
		$delim_label = "tab";
	}
	$fp = fopen("$workdir2/qsub.sh", 'w');
	if($if_allowSave){
    system("cp $workdir2$expfile /home/www/html/iris3/storage");
}

	if ($labelfile){
fwrite($fp,"#!/bin/bash\n 
#User uploaded cell label
wd=/home/www/html/iris3/data/$jobid/
exp_file=$expfile
label_file=$labelfile
jobid=$jobid
Rscript /home/www/html/iris3/program/genefilter.R \$wd\$exp_file \$jobid $delim
/home/www/html/iris3/program/qubic/qubic -i \$wd\$jobid\_filtered_expression.txt -d -f $f_arg -c $c_arg -k 18 -o $o_arg
for file in *blocks
do
grep Conds \$file |cut -d ':' -f2 >\"$(basename \$jobid\_blocks.conds.txt)\"
done
for file in *blocks
do
grep Genes \$file |cut -d ':' -f2 >\"$(basename \$jobid\_blocks.gene.txt)\"
done
Rscript /home/www/html/iris3/program/sc3.R \$wd\$jobid\_filtered_expression.txt \$jobid \$label_file\n
Rscript /home/www/html/iris3/program/ari_score.R \$label_file \$jobid $delim_label
Rscript /home/www/html/iris3/program/cts_gene_list.R \$wd\$jobid\_filtered_expression.txt \$jobid \$wd\$jobid\_cell_label.txt\n
Rscript /home/www/html/iris3/program/cvt_symbol.R \$wd \$wd\$jobid\_filtered_expression.txt\n 
perl /home/www/html/iris3/program/prepare_promoter.pl \$wd\n
/home/www/html/iris3/program/get_motif.sh \$wd\n
cd \$wd\n
find -name '*' -size 0 -delete\n
Rscript /home/www/html/iris3/program/prepare_bbc.R \$wd\n
touch bg \n
/home/www/html/iris3/program/get_bbc.sh \$wd\n
Rscript /home/www/html/iris3/program/merge_bbc.R \$wd\n
touch done\n 
perl /home/www/html/iris3/program/prepare_email.pl \$jobid\n

");
	} else {
		fwrite($fp,"#!/bin/bash\n 
#No label file
wd=/home/www/html/iris3/data/$jobid/
exp_file=$expfile
label_file=$labelfile
jobid=$jobid
Rscript /home/www/html/iris3/program/genefilter.R \$wd\$exp_file \$jobid $delim
/home/www/html/iris3/program/qubic/qubic -i \$wd\$jobid\_filtered_expression.txt -d -f $f_arg -c $c_arg -k 18 -o $o_arg
for file in *blocks
do
grep Conds \$file |cut -d ':' -f2 >\"$(basename \$jobid\_blocks.conds.txt)\"
done
for file in *blocks
do
grep Genes \$file |cut -d ':' -f2 >\"$(basename \$jobid\_blocks.gene.txt)\"
done
Rscript /home/www/html/iris3/program/sc3.R \$wd\$jobid\_filtered_expression.txt \$jobid 1\n
label_file=\$jobid\_sc3_label.txt
Rscript /home/www/html/iris3/program/ari_score.R \$label_file \$jobid tab
Rscript /home/www/html/iris3/program/cts_gene_list.R \$wd\$jobid\_filtered_expression.txt \$jobid \$wd\$jobid\_cell_label.txt\n
Rscript /home/www/html/iris3/program/cvt_symbol.R \$wd \$wd\$jobid\_filtered_expression.txt\n
perl /home/www/html/iris3/program/prepare_promoter.pl \$wd\n
/home/www/html/iris3/program/get_motif.sh \$wd\n
cd \$wd\n
find -name '*' -size 0 -delete\n
Rscript /home/www/html/iris3/program/prepare_bbc.R \$wd\n
touch bg \n
/home/www/html/iris3/program/get_bbc.sh \$wd\n
Rscript /home/www/html/iris3/program/merge_bbc.R \$wd\n
touch done\n 
perl /home/www/html/iris3/program/prepare_email.pl \$jobid\n
");}
	fclose($fp);
	session_destroy();
	system("chmod -R 777 $workdir2");
	$fp = fopen("$workdir2/param.txt", 'w+');
	fwrite($fp,"$jobid $workdir $selected_val $c_arg $k_arg $o_arg $f_arg $expfile");
	fclose($fp);
	system("cd $workdir; nohup sh qsub.sh > output.txt &");
	##shell_exec("$workdir/qsub.sh>$workdir/output.txt &");
	#header("Location: results.php?jobid=$jobid");
	header("Location: results.php?jobid=$jobid");
}else
{
	$smarty->display('submit.tpl');
}



?> 

