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
if($status=="done")
{
if(file_get_contents($tempnam.".motifinfo")=="")
{
    header("Location:err.php?jobid=$jobid&from=pred");
}
}



$_SESSION[$jobid."ann"]=$annotation1;
$smarty->assign('sy',$sy);
$smarty->assign('status',$status);
$smarty->assign('jobid',$jobid);
$smarty->assign('big',$big);
$smarty->assign('annotation', $annotation1);
$smarty->assign('LINKPATH', $LINKPATH);
        $smarty->display('results.tpl');

?>
