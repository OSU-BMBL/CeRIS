<?php
require_once("config/common.php");
require_once("config/smarty.php");
require_once("lib/spyc.php");
//require_once("lib/hmmer.php");
$jobid=$_GET['jobid'];
$filename=$_GET['file'];
$id=$_GET['id'];
$from=$_GET['from'];
$max=0;
$select="Motif-1";
$DATAPATH="/home/www/html/iris3/data";
$TOOLPATH="/home/www/html/iris3/program/dminda";
   session_start();
   $info = Spyc::YAMLLoad("$DATAPATH/$jobid/info.yaml");
$status=$info['status'];

$big=intval($info['big']);
$tempnam ="$DATAPATH/$jobid/$jobid";	
 if(strlen(file_get_contents($tempnam."bkg"))<10)
 {$sy=1;}
 else
 {$sy=2;}

if(file_exists($tempnam.".motifinfo")&& file_get_contents($tempnam.".motifinfo")!=""&&($status=="done"||$status=="Done"||$status=="Run")&&$sy==1)
{  



 /*  $key=0;
   $lengthseq=array();
   $fk = fopen("$DATAPATH/$jobid/$jobid"."tg", 'r');
	   while(!feof($fk)) 
	  	   {
	  	  $line=fgets($fk);
	      if(preg_match("/^>/",$line))
	      {$key++;
	      	
	      }
	      else
	      {
	      	$as=strlen($line);
	      		array_push($lengthseq,$as);
	      }
	  	   }
	  fclose($fk);  */
	  $i=0;
	    $num=0;
	    $result=array();
	    $array=array();   
	          $fp = fopen($tempnam.".motifinfo", 'r');
	             while(!feof($fp)) {
		                   $line=fgets($fp);
                           if(preg_match("/^\*{57}/",$line))
		                       	{    $line1=fgets($fp);
                               
		                       		if(!strlen($line1)!=1)
		                       		    {
                                     	$arr=explode(" ",chop($line1));
                                    if($arr[1]!="")
                                    { array_push($result,$arr[1]);}
                                  }
		                       	
		                       	} 
		                     if(strpos($line,"Consensus:"))
		                       	{
		                       		$i++;
		                       		
		                             	array_push($result,$i);
		                             	$arr=explode(" ",$line);
		                       	       array_push($result,$arr[2]);
		                       	
		                       	}
		                   
		                       	if(strpos($line,"Motif length:"))
		                       	{$arr=explode(" ",$line);
		                       
		                       	array_push($result,$arr[3]);
		                       	}
		                       	if(strpos($line,"Binding sites number:"))
		                       	{$arr=explode(" ",$line);
		                       			$num=(int)$arr[4];
		                    
		                       	array_push($result,$arr[4]);
		                       	}
		                       	if(strpos($line,"Pvalue:"))
		                       	{$arr=explode(" ",$line);
		                       	array_push($result,$arr[2]);
		                       	}
		                       
		                       	if(strpos($line,"Searched binding sites  of current Motif"))
		                       	{$line=fgets($fp);
		                       	while($num!=-5)
		                       	{$key1=0;
		                       		$line=fgets($fp);
		                       //echo $i."!$num!$line<br>";
		                       // echo "$key==$key1,$num,$line,<br>";
		                        if(strpos($line,"the best")&&strpos($line,"convinced"))
		                        {	$arr=explode(" ",$line);
		                        	$key1=(int)$arr[2];
		                       		array_push($result,$arr[2]);
		                       	array_push($result,$arr[11]);
		                       		}
		                       else if((!strpos($line,"the best"))&&strpos($line,"convinced"))
		                       {$arr=explode(" ",$line);
		                 
		                       	array_push($result,$arr[2]);
		                       	array_push($result,$arr[9]);
		                       	}
		                       	 else if(strpos($line,"the best")&&(!strpos($line,"convinced"))&&$num==-1)
		                       {$arr=explode(" ",$line);
		                 
		                       	array_push($result,$arr[2]);
		                       	array_push($result,$arr[10]);
		                       	}
		
		                       else if(strpos($line,'>')===0)
		                       { 
		                       	$arr=explode("\t",$line);
		                       	array_push($array,$arr[1]);
		                       	array_push($array,$arr[2]);
		                       	array_push($array,$arr[3]);
		                       	array_push($array,$arr[4]);
		                       	array_push($array,$arr[5]);
		                        array_push($array,$arr[6]);
		                      }
		                       	$num=$num-1;
		                       	}
		                       	
		                       	$num=0;
		                       	}
	                     }
	
	          fclose($fp);
    
	     $n=0;$m=0;$i=0;
	     $annotation1=array();
	     $motifs=array();
	  $scr="#!/usr/bin/env sh\ncd $TOOLPATH/weblogo-3.3\n";
	for($k=0;$k<=count($result);$k++)
	{
		if(($k+1)%8==5)
		{$m=(int)$result[$k];
		}
		if(($k+1)%8==0)
		{  $j=0;
				//$fp= fopen ($tempnam."-motifin".($i+1), 'w');
		
		while($m!=0){
			if($j<(int)$result[$k-1])
			{
				$motifs[$j]=array(
						'red'=>1,
						'Seq'=>$array[$n],
						'start'=>$array[$n+1],
						'end'=>$array[$n+3],
						'Motif'=>$array[$n+2],
						'Score'=>$array[$n+4],
						'Info'=>$array[$n+5],
            //'seqlen'=>$lengthseq[($array[$n]-1)],
            );
			}
			else {
				$motifs[$j]=array(
						'red'=>0,
						'Seq'=>$array[$n],
						'start'=>$array[$n+1],
						'Motif'=>$array[$n+2],
						'end'=>$array[$n+3],
						'Score'=>$array[$n+4],
						'Info'=>$array[$n+5],
            //'seqlen'=>$lengthseq[($array[$n]-1)],
            );
						
			}

      //  fwrite($fp, ">".($j+1)."\n");
	     //  fwrite($fp, $array[$n+2]."\n");
	    
					$n=$n+6;
					$m--;
					$j++;
	     }
	// fclose($fp);

//$scr=$scr."./weblogo --format PNG --color black A 'PurineA' --color green G 'PurineG' --color red T 'PyrimidineT' --color blue C 'PyrimidineC' < ".$tempnam."-motifin".($i+1)." > ".$tempnam."-motifin".($i+1).".png\n";
	 	$annotation1[$i]=array(
	 	    'Motifname'=>$result[$k-7],
	 			'Motifid'=>$result[$k-6],
	 			'Consensus'=>$result[$k-5],
	 			'Motiflength'=>$result[$k-4],
	 			'Motifnumber'=>$result[$k-3],
	 			'MotifPvalue'=>$result[$k-2],
	 			'firstn'=>$result[$k-1],
	 			'firstp'=>$result[$k],
	 		
	 			'Motifs'=>$motifs
	 	        );
			unset($motifs);
			 
			 
			$i++;
    }
	
		
	}
   /*  $fp = fopen("$DATAPATH/$jobid/weblogo.sh", 'w');
     fwrite($fp, $scr);
     fclose($fp);
	   if($status=="done")
     {    
       system("nohup sh $DATAPATH/$jobid/weblogo.sh >wlog &");
       $status="Run";
        	$info['status']= $status;
          $fp = fopen("$DATAPATH/$jobid/info.yaml", 'w');
          fwrite($fp, Spyc::YAMLDump($info));
          fclose($fp);
      
     } 
	      if(file_exists($tempnam.$annotation1[count($annotation1)-1]['Motifname'].".png") )
         { $status="Done";
        	$info['status']= $status;
          $fp = fopen("$DATAPATH/$jobid/info.yaml", 'w');
          fwrite($fp, Spyc::YAMLDump($info));
          fclose($fp);
        } */
        
    $status="Done";
        	$info['status']= $status;
          $fp = fopen("$DATAPATH/$jobid/info.yaml", 'w');
          fwrite($fp, Spyc::YAMLDump($info));
          fclose($fp);

}else{
}

if(file_exists($tempnam.".motifinfo")&&file_get_contents($tempnam.".motifinfo")!=""&&($status=="done"||$status=="Done"||$status=="Run")&&$sy==2)
{   /*  $key=0;
   $lengthseq=array();
   $fk = fopen("$DATAPATH/$jobid/$jobid"."tg", 'r');
	   while(!feof($fk)) 
	  	   {
	  	  $line=fgets($fk);
	      if(preg_match("/^>/",$line))
	      {$key++;
	      	
	      }
	      else
	      {
	      	$as=strlen($line);
	      		array_push($lengthseq,$as);
	      }
	  	   }
	  fclose($fk);  */
	  $i=0;
	    $num=0;
	    $result=array();
	    $array=array();   
	          $fp = fopen($tempnam.".motifinfo", 'r');
	             while(!feof($fp)) {
		                   $line=fgets($fp);
                               if(preg_match("/^\*{57}/",$line))
		                       	{    $line1=fgets($fp);
                               
		                       		if(!strlen($line1)!=1)
		                       		    {
                                     	$arr=explode(" ",chop($line1));
                                    if($arr[1]!="")
                                    { array_push($result,$arr[1]);}
                                  }
		                       	
		                       	} 
		                     if(strpos($line,"Consensus:"))
		                       	{
		                       		$i++;
		                       		
		                             	array_push($result,$i);
		                             	$arr=explode(" ",$line);
		                       	       array_push($result,$arr[2]);
		                       	
		                       	}
		                   
		                       	if(strpos($line,"Motif length:"))
		                       	{$arr=explode(" ",$line);
		                       
		                       	array_push($result,$arr[3]);
		                       	}
		                       	if(strpos($line,"Binding sites number:"))
		                       	{$arr=explode(" ",$line);
		                       			$num=(int)$arr[4];
		                    
		                       	array_push($result,$arr[4]);
		                       	}
		                       	if(strpos($line,"Pvalue:"))
		                       	{$arr=explode(" ",$line);
		                       	array_push($result,$arr[2]);
		                       	}
                            if(strpos($line,"Zscore:"))
		                       	{$arr=explode(" ",$line);
                            if(intval($arr[2])>30) {$arr[2]=30;}
		                       	array_push($result,$arr[2]);
		                       	}
		                        
		                       	if(strpos($line,"Searched binding sites  of current Motif"))
		                       	{$line=fgets($fp);
		                       	while($num!=-5)
		                       	{$key1=0;
		                       		$line=fgets($fp);
		                       //echo $i."!$num!$line<br>";
		                       // echo "$key==$key1,$num,$line,<br>";
		                        if(strpos($line,"the best")&&strpos($line,"convinced"))
		                        {	$arr=explode(" ",$line);
		                        	$key1=(int)$arr[2];
		                       		array_push($result,$arr[2]);
		                       	array_push($result,$arr[11]);
		                       		}
		                       else if((!strpos($line,"the best"))&&strpos($line,"convinced"))
		                       {$arr=explode(" ",$line);
		                 
		                       	array_push($result,$arr[2]);
		                       	array_push($result,$arr[9]);
		                       	}
		                       	 else if(strpos($line,"the best")&&(!strpos($line,"convinced"))&&$num==-1)
		                       {$arr=explode(" ",$line);
		                 
		                       	array_push($result,$arr[2]);
		                       	array_push($result,$arr[10]);
		                       	}
		
		                       else if(strpos($line,'>')===0)
		                       { 
		                       	$arr=explode("\t",$line);
		                       	array_push($array,$arr[1]);
		                       	array_push($array,$arr[2]);
		                       	array_push($array,$arr[3]);
		                       	array_push($array,$arr[4]);
		                       	array_push($array,$arr[5]);
		                        array_push($array,$arr[6]);
		                      }
		                       	$num=$num-1;
		                       	}
		                       	
		                       	$num=0;
		                       	}
	                     }
	
	          fclose($fp);
	     $n=0;$m=0;$i=0;
	     $annotation1=array();
	     $motifs=array();
	  $scr="#!/usr/bin/env sh\ncd $TOOLPATH/weblogo-3.3\n";
	for($k=0;$k<=count($result);$k++)
	{
		if(($k+1)%9==5)
		{$m=(int)$result[$k];
		}
		if(($k+1)%9==0)
		{  $j=0;
			//	$fp= fopen ($tempnam."-motifin".($i+1), 'w');

		while($m!=0){
			if($j<(int)$result[$k-1])
			{
				$motifs[$j]=array(
						'red'=>1,
						'Seq'=>$array[$n],
						'start'=>$array[$n+1],
						'end'=>$array[$n+3],
						'Motif'=>$array[$n+2],
						'Score'=>$array[$n+4],
						'Info'=>$array[$n+5],
           // 'seqlen'=>$lengthseq[($array[$n]-1)],
            );
			}
			else {
				$motifs[$j]=array(
						'red'=>0,
						'Seq'=>$array[$n],
						'start'=>$array[$n+1],
						'Motif'=>$array[$n+2],
						'end'=>$array[$n+3],
						'Score'=>$array[$n+4],
						'Info'=>$array[$n+5],
          //  'seqlen'=>$lengthseq[($array[$n]-1)],
            );
						
			}

       // fwrite($fp, ">".($j+1)."\n");
	      // fwrite($fp, $array[$n+2]."\n");
	       // fwrite($fm, $array[$n+2]."\n");
					$n=$n+6;
					$m--;
					$j++;
	     }
	// fclose($fp);

//$scr=$scr."./weblogo --format PNG --color black A 'PurineA' --color green G 'PurineG' --color red T 'PyrimidineT' --color blue C 'PyrimidineC' < ".$tempnam."-motifin".($i+1)." > ".$tempnam."-motifin".($i+1).".png\n";
	 	$annotation1[$i]=array(
	 	    'Motifname'=>$result[$k-8],
	 			'Motifid'=>$result[$k-7],
	 			'Consensus'=>$result[$k-6],
	 			'Motiflength'=>$result[$k-5],
	 			'Motifnumber'=>$result[$k-4],
	 			'MotifPvalue'=>$result[$k-3],
        'Zscore'=>$result[$k-2],
	 			'firstn'=>$result[$k-1],
	 			'firstp'=>$result[$k],
	 		
	 			'Motifs'=>$motifs
	 	        );
			unset($motifs);
			 
			 
			$i++;
    }
	
		
	}
    /* $fp = fopen("$DATAPATH/$jobid/weblogo.sh", 'w');
     fwrite($fp, $scr);
     fclose($fp);
	   if($status=="done")
     {    
       system("nohup sh $DATAPATH/$jobid/weblogo.sh >wlog &");
       $status="Run";
        	$info['status']= $status;
          $fp = fopen("$DATAPATH/$jobid/info.yaml", 'w');
          fwrite($fp, Spyc::YAMLDump($info));
          fclose($fp);
      
     }  
	      if(file_exists($tempnam.$annotation1[count($annotation1)-1]['Motifname'].".png") )
         { $status="Done";
        	$info['status']= $status;
          $fp = fopen("$DATAPATH/$jobid/info.yaml", 'w');
          fwrite($fp, Spyc::YAMLDump($info));
          fclose($fp);
        } 
     */
    $status="Done";
        	$info['status']= $status;
          $fp = fopen("$DATAPATH/$jobid/info.yaml", 'w');
          fwrite($fp, Spyc::YAMLDump($info));
          fclose($fp);
}else{
}
   for($i=0;$i<count($annotation1);$i++)
   {
          if($annotation1[$i]['Motifid']==$id)
          {    $select= $annotation1[$i]['Motifname'];
				#print_r($select);
          	   system("cat $DATAPATH/$jobid/$select |python $TOOLPATH/motif_tools/align2matrix.py > $DATAPATH/$jobid/$select.matrix");
             system("cat $DATAPATH/$jobid/$select | perl $TOOLPATH/motif_tools/align2uniprobe.pl > $DATAPATH/$jobid/$select.uniprobe");
             system("cat $DATAPATH/$jobid/$select.uniprobe | perl $TOOLPATH/motif_tools/uniprobe2meme > $DATAPATH/$jobid/$select.meme");
                break;
          }
         
      
   }
   if($from==="scan")
   {$workdir="$DATAPATH/$jobid";
   $show=array();
   $key=0;$max=0;$lengthseq=array();
	  $fp = fopen($workdir."/$jobid"."tg", 'r');
	   while(!feof($fp)) 
	  	   {
	  	  $line=fgets($fp);
	      if(preg_match("/^>/",$line))
	      {$key++;
	     
	      $line=fgets($fp);
	      		if($max<strlen($line)) $max=strlen($line);
	      $show[$key]['len']=strlen($line);
	       $show[$key]['motifs']=array();
	      	}
	  	   }
	  fclose($fp);
    system("cat $DATAPATH/$jobid/$select | perl $TOOLPATH/motif_tools/align2matrix.py > $DATAPATH/$jobid/$select.matrix");
system("cat $DATAPATH/$jobid/$select | perl $TOOLPATH/motif_tools/align2uniprobe.pl > $DATAPATH/$jobid/$select.uniprobe");
system("cat $DATAPATH/$jobid/$select.uniprobe | perl $TOOLPATH/motif_tools/uniprobe2meme > $DATAPATH/$jobid/$select.meme");
     }
     else if($from==="ref")
     {
             $workdir="$DATAPATH/$jobid";
      $show=array();
      $key=0;$max=0;$lengthseq=array();
	     $fp = fopen($workdir."/output/promoters", 'r');
	     while(!feof($fp)) 
	  	   {
	  	  $line=fgets($fp);
	      if(preg_match("/^>/",$line))
	      {$key++;
	     
	      $line=fgets($fp);
	      		if($max<strlen($line)) $max=strlen($line);
	      $show[$key]['len']=strlen($line);
	       $show[$key]['motifs']=array();
	      	}
	  	   }
	  fclose($fp);
    system("cat $DATAPATH/$jobid/output/$select | perl $TOOLPATH/motif_tools/align2matrix.py > $DATAPATH/$jobid/$select.matrix");
system("cat $DATAPATH/$jobid/output/$select | perl $TOOLPATH/motif_tools/align2uniprobe.pl > $DATAPATH/$jobid/$select.uniprobe");
system("cat $DATAPATH/$jobid/output/$select.uniprobe | perl $TOOLPATH/motif_tools/uniprobe2meme > $DATAPATH/$jobid/$select.meme");
     }
     else if($from==="mp3")
     {
        $workdir="$DATAPATH/$jobid";
      $show=array();
      $key=0;$max=0;$lengthseq=array();
	     $fp = fopen($workdir."/$jobid"."tg","r");
	     while(!feof($fp)) 
	  	   {
	  	  $line=fgets($fp);
	      if(preg_match("/^>/",$line))
	      {$key++;
	     
	      $line=fgets($fp);
	      		if($max<strlen($line)) $max=strlen($line);
	      $show[$key]['len']=strlen($line);
	       $show[$key]['motifs']=array();
	      	}
	  	   }
	   }
	  	else
     {
        $workdir="$DATAPATH/$jobid";
      $show=array();
      $key=0;$max=0;$lengthseq=array();
	     $fp = fopen($workdir."/$jobid"."tg", 'r');
	     while(!feof($fp)) 
	  	   {
	  	  $line=fgets($fp);
	      if(preg_match("/^>/",$line))
	      {$key++;
	     
	      $line=fgets($fp);
	      		if($max<strlen($line)) $max=strlen($line);
	      $show[$key]['len']=strlen($line);
	       $show[$key]['motifs']=array();
	      	}
	  	   }
	  fclose($fp);
   
     }
    $showann=array();


	  	  for($i=0;$i<count($annotation1);$i++)
	  	   {  
	  	   	if($annotation1[$i]['Motifid']==$id)
	  	   	{     $showann[0]=$annotation1[$i];
	  	   		for($z=0;$z<count($annotation1[$i]['Motifs']);$z++)
	  	   		{
	  	   			  
	  	   			  $result=array(
	  	   			  'name'=>$annotation1[$i]['Motifname'],
	  	   			  'start'=>$annotation1[$i]['Motifs'][$z]['start'],
	  	   			  'end'=>$annotation1[$i]['Motifs'][$z]['end'],
                'id'=>$annotation1[$i]['Motifs'][$z]['id'],
	  	   			  );
	  	   		
	  	   			       #print_r($result);
	  	   			  array_push($show[(int)$annotation1[$i]['Motifs'][$z]['Seq']]['motifs'],$result);
                //print_r();
	  	   			}
	  	   		
	  	   	}
	  	   	
	  	  }
	  	 

    
   $_SESSION[$jobid."show"]=$show;
   $ScaleLen=840;
   $GridUnit=5;
   $LabelUnit=10;
   $WinWidth=870;
   $Unit=10;
   $MinLabel=$max/($ScaleLen/$GridUnit);
   $blank=0;
   $imagesrc=array();
  $n=0;
for($i=1;$i<=count($show);$i++)
{    $seqlen=$show[$i]['len'];

	   if($seqlen< $max)
	    {$ScaleLen=$seqlen*($GridUnit/$MinLabel);
	    	$blank=($max-$seqlen);
	    }
	  else{ $ScaleLen=840;$blank=0;}
	 if($show[$i]['motifs']!=null)
		{$imagesrc[$n]=array(
		 'ScaleLen'=>$ScaleLen,
     'GridUnit'=>$GridUnit,
     'LabelUnit'=>$LabelUnit,
     'WinWidth'=>$WinWidth,
     'Unit'=>$Unit,
      'MinLabel'=>$MinLabel,
      'id'=>$i,
      'jobid1'=>$jobid,
      'blank'=>$blank,
		);
		$n++;
		}
		
}

  $matrix="";
 
  //cat /home/www/html/bobro/data/20131124133808/Motif-1 | perl /home/www/html/bobro/tools/motif_tools/uniprobe2meme > /home/www/html/bobro/data/20131124133808/Motif-1.meme
    //$matrix=$matrix."-----------------------------------------Motif Matrix Format--------------------------------------"."\n";
    if($fp = fopen("$DATAPATH/$jobid/$select.matrix", 'r')){
	
	   while(!feof($fp)) 
	  	   {
	  	  $line=fgets($fp);
	       $matrix=$matrix.$line;
	  	   }
	
	  fclose($fp);
	}
    //$matrix=$matrix."--------------------------------------Motif Uniprobe Format------------------------------------"."\n";
    if( $fp = fopen("$DATAPATH/$jobid/$select.uniprobe", 'r')){
		
	
	   while(!feof($fp)) 
	  	   {
	  	  $line=fgets($fp);
	       $matrix=$matrix.$line;
	  	   }
	  fclose($fp);
	  }
    //$matrix=$matrix."---------------------------------------Motif meme Format----------------------------------------"."\n";
       if($fp = fopen("$DATAPATH/$jobid/$select.meme", 'r')){
	   while(!feof($fp)) 
	  	   {
	  	  $line=fgets($fp);
	       $matrix=$matrix.$line; 
	  	   }
	  fclose($fp);
	   }
$smarty->assign('filename',$filename);
$smarty->assign('jobid',$jobid);
$status="Done";
$smarty->assign('from',$from);
$smarty->assign('id',$id);
$smarty->assign('matrix',$matrix);
$smarty->assign('status',$status);
$smarty->assign('ann', $showann);
$smarty->assign('src', $imagesrc);
$smarty->assign('BOBRO2PATH', $BOBRO2PATH);
$smarty->display('motif_detail.tpl');

?>
