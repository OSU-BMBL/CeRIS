 var $J = jQuery.noConflict();
   var table1;
   var st=0;
 $J(document).ready(function(){ 
       
     	var el = document.getElementById('control');
                                         
       	var elb = document.getElementById('Inputsequence');
          	var elct = document.getElementById('Targetsequence3');
            	var elct2 = document.getElementById('mp3t');			
        var elc = document.getElementById('organism');	
       	 var eld = document.getElementById('emailfd');	
       	 	var els = document.getElementById('showspecies'); 
       	var elr = document.getElementById('reference');
        var op = document.getElementById('option');
        var ops = document.getElementById('options');
          var opc = document.getElementById('optionc');
          var opr = document.getElementById('optionr');
         var qu = document.getElementById('query');
          var fdiv = document.getElementById('fdiv');
           var rdiv = document.getElementById('rdiv');
           var gpfd0 = document.getElementById('gpfd0');
             var gpfd1 = document.getElementById('gpfd1'); 
              var gpfd2 = document.getElementById('gpfd2');
               var gpfd3 = document.getElementById('gpfd3');
               var gpfd4 = document.getElementById('gpfd4'); 
               var gpfd4r = document.getElementById('regulongpfd'); 
				var gpfd5 = document.getElementById('gpfd4m');     
          var emailrd = document.getElementById('emailrd');
       	var checkdata="";
       	nc_name="";
	spe_name="";
	spe_dirname="";
   document.getElementById('myframegpfd4m').src="preparedoor.php?st=5";
try {
           document.getElementById('myframegpfdregulon').src="preparedoor.php?st=6";
}
catch(err) {
   
}


   $J("#form2").submit( function() {
          var str = "";
          var str2 = "";
        $J( "#select2 option" ).each(function() {
              str+= $J( this ).val() + ";";
              str2+= $J( this ).text() + ";";
           });
           var numr=$J("input#numr").val();
           var minr=$J("input#minr").val();
           var maxr=$J("input#maxr").val();
          var emailr=$J("input#emailr").val();
     	$J("div#content").html("<div style=\"text-align: center;\"> <p> <img src=\"static/images/busy.gif\" /> <br/></p><p>Your request is received.<br/>Please wait a few seconds. </p></div>");  
			$J.post("motif_prediction_with_reference.php",{check:checkdata,numr:numr,minr:minr,maxr:maxr,emailr:emailr,refnc:str,refname:str2,ncname:nc_name,spedirname:spe_dirname},function(data){window.location.href="motif_annotation_prediction_with_reference.php?jobid="+data;},"text");

					return false;
				} );         
   
		$J('span#remove1').click(function(){
			var $removeOptions = $J('#select2 option:selected');
			$removeOptions.appendTo('#select1');
		});
		
		  $J("span#add1").click(function(){
			var $removeOptions = $J('#select1 option:selected');
			$removeOptions.appendTo('#select2');
		});
		
		
		$J('#addAll').click(function(){
			var $options = $J('#select1 option');
			$options.appendTo('#select2');
		});
		
		$J('#removeAll').click(function(){
			var $options = $J('#select2 option');
			$options.appendTo('#select1');
		});
		$J('#select1').dblclick(function(){
				$J('#select1 option:selected').appendTo('#select2');
		});
		
		$J('#select2').dblclick(function(){
			$J('#select2 option:selected').appendTo('#select1');
		});
    
 
$J( "input#preparedata" ).click(function(){
	 elr.style.display='';
	 els.style.display='none';
     elc.style.display='none';
      rdiv.style.display='';
      opr.style.display='none';
       emailrd.style.display='';	
	checkdata=myframe.window.getdata();
	nc_name=myframe.window.nc_name();
	spe_name=myframe.window.spe_name();
	spe_dirname=myframe.window.spe_dirname();   
	 
	 
});

$J( "select#specm" ).change(function () {
       var value=$J( this ).val();
       	var elm0 = document.getElementById('m0');
       	var elm1 = document.getElementById('m1');
       	var elm2 = document.getElementById('m2');	
       	
    if(value==1)
     {
     elm0.style.display='';
      elm1.style.display='none';
     elm2.style.display='none';
      ops.style.display='none';
     }
	 else if(value==2)
     {
      elm0.style.display='none';
       elm1.style.display='';
       elm2.style.display='none';
        ops.style.display='none';
     }
    else if(value==3)
     {
     elm0.style.display='none';
     elm1.style.display='none';
     elm2.style.display='';
      ops.style.display='none';
     }
      });
      
  $J( "select#specm3" ).change(function () {
       var value=$J( this ).val();
       	var elm0 = document.getElementById('m03');
       	var elm1 = document.getElementById('m13');
       	var elm2 = document.getElementById('m23');	
       	
    if(value==1)
     {
     elm0.style.display='';
      elm1.style.display='none';
     elm2.style.display='none';
    
     }
	 else if(value==2)
     {
      elm0.style.display='none';
       elm1.style.display='';
       elm2.style.display='none';
  
     }
    else if(value==3)
     {
     elm0.style.display='none';
     elm1.style.display='none';
     elm2.style.display='';
  
     }
      });
      
  $J( "span#fop" ).click(function () {
        if(op.style.display=='none')
       {op.style.display='';}
        else{op.style.display='none';}
      });
      
      $J( "span#qcop" ).click(function () {
        if(el.style.display=='none')
       {el.style.display='';}
        else{el.style.display='none';}
      });
      
         $J( "span#ccop" ).click(function () {
        if(elct.style.display=='none')
       {elct.style.display='';}
        else{elct.style.display='none';}
      });
        
      
   $J( "span#rop" ).click(function () {
        if(opr.style.display=='none')
       {opr.style.display='';}
        else{opr.style.display='none';}
      });
  $J( "span#sop" ).click(function () {
        if(ops.style.display=='none')
       {ops.style.display='';}
        else{ops.style.display='none';}
      });
    $J( "span#cop" ).click(function () {
        if(opc.style.display=='none')
       {opc.style.display='';}
        else{opc.style.display='none';}
      });
      
       $J( "span#sfda" ).click(function () {
        st=0;
        if(gpfd0.style.display=='none')
       {gpfd0.style.display='';}
        else{
        document.getElementById('myframegpfd0').src="preparedoor.php?st="+st;
        gpfd0.style.display='none';}
      });
      
       $J( "span#sfdb" ).click(function () {
        st=1;
        if(gpfd1.style.display=='none')
       {gpfd1.style.display='';}
        else{
        document.getElementById('myframegpfd1').src="controldoor.php?st="+st;
        gpfd1.style.display='none';}
      });
      
      
       $J( "span#sfdc" ).click(function () {
        st=2;
        if(gpfd2.style.display=='none')
       {gpfd2.style.display='';}
        else{
        document.getElementById('myframegpfd2').src="preparedoor.php?st="+st;
        gpfd2.style.display='none';}
      });
      
         $J( "span#sfdd" ).click(function () {
        st=3;
        if(gpfd3.style.display=='none')
       {gpfd3.style.display='';}
        else{
        document.getElementById('myframegpfd3').src="preparedoor.php?st="+st;
        gpfd3.style.display='none';}
      });
      
        $J( "span#sfde" ).click(function () {
        st=4;
        if(gpfd4.style.display=='none')
       {gpfd4.style.display='';}
        else{
        document.getElementById('myframegpfd4').src="preparedoor.php?st="+st;
        gpfd4.style.display='none';}
      });
         $J( "span#mp3sfdb" ).click(function () {
                if(gpfd4m.style.display=='none')
       {gpfd4m.style.display='';}
        else{
        
        gpfd4m.style.display='none';}
      });
      
       $J( "span#regulonsfdb" ).click(function () {
       
        if(gpfd4r.style.display=='none')
       {gpfd4r.style.display='';}
        else{
        gpfd4r.style.display='none';}
      });
      
     $J( "span#sa1" ).click(function () {
      document.getElementById('sequencef').value=document.getElementById('samplep').value;
      
      });
       $J( "span#sa2" ).click(function () {
      document.getElementById('sequence1').value=document.getElementById('samplep1').value;
      
      });
        $J( "span#mp3sa2" ).click(function () {
      document.getElementById('mp3t1c').value=document.getElementById('mp3sample').value;
      
      });
        $J( "span#sa3" ).click(function () {
      document.getElementById('sequence23').value=document.getElementById('sm1').value;
      
      });
         $J( "span#sa4" ).click(function () {
      document.getElementById('sequence23').value=document.getElementById('sm2').value;
      
      });
         $J( "span#sa5" ).click(function () {
      document.getElementById('sequence23').value=document.getElementById('sm3').value;
      
      });
       $J( "span#sa6" ).click(function () {
      document.getElementById('sequence13').value=document.getElementById('samplepp1').value;
      
      });
       $J( "span#sa7" ).click(function () {
      document.getElementById('sequence2').value=document.getElementById('samplep1').value;
      
      });
            $J( "span#sa8" ).click(function () {
      document.getElementById('sequence23c').value=document.getElementById('sm1').value;
      
      });
       $J( "span#sa9" ).click(function () {
      document.getElementById('sequence13c').value=document.getElementById('samplepp1').value;
      
      });
  
         $J( "span#sa10" ).click(function () {
      document.getElementById('sequence23c').value=document.getElementById('sm2').value;
      
      });
         $J( "span#sa11" ).click(function () {
      document.getElementById('sequence23c').value=document.getElementById('sm3').value;
      
      });


	$J( "span#regulonsa2" ).click(function () {
		document.getElementById('regulont1c').value=document.getElementById('regulonSample').value;  
    });
      
      
       $J( "span#sc1" ).click(function () {
      document.getElementById('sequencef').value="";
      
      });
       $J( "span#sc2" ).click(function () {
      document.getElementById('sequence1').value="";
      
      });
        $J( "span#mp3sc2" ).click(function () {
      document.getElementById('mp3t1c').value="";      
      });
        $J( "span#sc3" ).click(function () {
      document.getElementById('sequence23').value="";
      
      });
         $J( "span#sc4" ).click(function () {
     document.getElementById('sequence13').value="";
      
      });
         $J( "span#sc5" ).click(function () {
      document.getElementById('sequence2').value="";
      
      });
       $J( "span#sc6" ).click(function () {
      document.getElementById('sequence23c').value="";
      
      });
       $J( "span#sc7" ).click(function () {
      document.getElementById('sequence13c').value="";
      
      });
      
        $J( "span#regulonsc2" ).click(function () {
       
      document.getElementById('regulont1c').value="";
      
      
      });
 $J( "select#spec2" ).change(function () {
       var value=$J( this ).val();
       	var elc = document.getElementById('control1');
    if(value=='Y')
     {
     elc.style.display='';
     }
	 else if(value=='N')
     {
   elc.style.display='none';
     }
      }).change();
      
     $J( "select#spec2c" ).change(function () {
       var value=$J( this ).val();
       	var elc = document.getElementById('Targetsequence3');
    if(value=='Y')
     {
     elc.style.display='';
     }
	 else if(value=='N')
     {
   elc.style.display='none';
     }
      }).change();
   
}); 


function showdata(aad){

  if(aad==0)
	 {document.getElementById('sequencef').value=myframegpfd0.window.getdatap();
     
	   gpfd0.style.display='none';
     }
    if(aad==1)
	 {document.getElementById('sequence1').value=myframegpfd1.window.getdatap();
	   gpfd1.style.display='none';}
        if(aad==2)
	 {document.getElementById('sequence13').value=myframegpfd2.window.getdatap();
	   gpfd2.style.display='none';}
        if(aad==3)
	 {document.getElementById('sequence2').value=myframegpfd3.window.getdatap();
	   gpfd3.style.display='none';}
     
         if(aad==4)
	 {document.getElementById('sequence13c').value=myframegpfd4.window.getdatap();
	   gpfd4.style.display='none';}
       if(aad==5)
	 {
       document.getElementById('mp3t1c').value=myframegpfd4m.window.getdatap();
	   gpfd4m.style.display='none';}

	 if(aad==6){
		document.getElementById('regulont1').value=myframegpfdregulon.window.getdatap();
	    gpfd4m.style.display='none';}
	 }
} 

function setMP3(ASD){

          st=5;
        document.getElementById('myframegpfd4m').src="preparedoor.php?st="+st;

} 
function setregulon(ASDL){

          st=6;
        document.getElementById('myframegpfdregulon').src="preparedoor.php?st="+st;

}   

function setNC(ASDL){
          alert(ASDL.value);
        document.getElementById('orNC').value=ASDL.value;

}   