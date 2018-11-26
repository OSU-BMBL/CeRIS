var $J = jQuery.noConflict();
var table1;
var st;
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
		
	try {
		//document.getElementById('myframegpfd2').src="preparedoor.php?st=2";
		//document.getElementById('myframegpfd4m').src="preparedoor.php?st=5";
		//document.getElementById('myframegpfdregulon').src="preparedoor.php?st=6";
	}catch(err) {
		
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
       	
		if(value==1){
			elm0.style.display='';
			elm1.style.display='none';
			elm2.style.display='none';
			ops.style.display='none';
		}else if(value==2){
			elm0.style.display='none';
			elm1.style.display='';
			elm2.style.display='none';
				ops.style.display='none';
		}else if(value==3){
			elm0.style.display='none';
			elm1.style.display='none';
			elm2.style.display='';
			ops.style.display='none';
		}
    });
      
	$J( "select#specm3" ).change(function () {
		var value = $J( this ).val();
       	var elm0 = document.getElementById('m03');
       	var elm1 = document.getElementById('m13');
       	var elm2 = document.getElementById('m23');	
       	
		var mc_align = document.getElementById('mc_align');
		var mc_matrix = document.getElementById('mc_matrix');
		var mc_consensus = document.getElementById('mc_consensus');
		if(value==1){
			elm0.style.display='';
			elm1.style.display='none';
			elm2.style.display='none';    
			
			mc_align.style.display = '';
			mc_matrix.style.display = 'none';
			mc_consensus.style.display = 'none';
		}else if(value==2){
			elm0.style.display='none';
			elm1.style.display='';
			elm2.style.display='none';  
			
			mc_align.style.display = 'none';
			mc_matrix.style.display = '';
			mc_consensus.style.display = 'none';
		}else if(value==3){
			elm0.style.display='none';
			elm1.style.display='none';
			elm2.style.display=''; 
			
			mc_align.style.display = 'none';
			mc_matrix.style.display = 'none';
			mc_consensus.style.display = '';
		}
    });
      
	$J( "button#fop" ).click(function () {
        if(op.style.display=='none'){
			op.style.display='';
		}else{
			op.style.display='none';}
    });
      
    $J( "button#qcop" ).click(function () {
        if(el.style.display=='none'){
			el.style.display='';
		}else{
			el.style.display='none';}
    });
      
    $J( "button#ccop" ).click(function () {	 
        if(elct.style.display=='none'){
			elct.style.display='';
		}else{
			elct.style.display='none';}
    });
        
      
    $J( "span#rop" ).click(function () {
        if(opr.style.display=='none'){
			opr.style.display='';
	}else{
		opr.style.display='none';}
    });
	  
	$J( "span#sop" ).click(function () {
        if(ops.style.display=='none'){
			ops.style.display='';
		}else{
			ops.style.display='none';}
    });
	
    $J( "button#cop" ).click(function () {
        if(opc.style.display=='none')
       {opc.style.display='';}
        else{opc.style.display='none';}
      });
      
    $J( "button#sfda" ).click(function () {
        st=0;
        if (gpfd0.style.display=='none') {
			document.getElementById('myframegpfd0').src="preparedoor.php?st="+st;
			gpfd0.style.display='';
		} else {			
			gpfd0.style.display='none';
		}
	});
     
	$J("button#eukaMF").click(function() {
		st=0;
		if (gpfd0.style.display == 'none') {
			document.getElementById('myframegpfd0').src = "displayGroups.php?part=Y&st=" + st;
			gpfd0.style.display = 'inline';
		} else {
			gpfd0.style.display = 'none';
		}
	});
	
    $J( "a#sfdb" ).click(function () {
        st=1;
        if(gpfd1.style.display=='none'){
			gpfd1.style.display='';
			document.getElementById('myframegpfd1').src="controldoor.php?st="+st;
		} else {			
			gpfd1.style.display='none';
		}
	});
    
	$J("a#eukaMF_cont").click(function() {
		st = 1;		
		if (gpfd1.style.display == 'none') {				
			document.getElementById('myframegpfd1').src = "displayGroups.php?part=Y&cont=Y&st=" + st;
			gpfd1.style.display = 'inline';
		} else {
			gpfd1.style.display = 'none';
		}
	});
      
	$J( "a#sfdc" ).click(function () {
		st = 2;
		if(gpfd2.style.display=='none'){
			document.getElementById('myframegpfd2').src="preparedoor.php?st="+st;
			gpfd2.style.display='';
		}else{									
			gpfd2.style.display='none';
		}
	});
      
	$J("a#eukaMS").click(function() {
		st=2;
		if (gpfd2.style.display == 'none') {
			document.getElementById('myframegpfd2').src = "displayGroups.php?part=Y&st=" + st;
			gpfd2.style.display = '';
		} else {
			gpfd2.style.display = 'none';
		}
	});
	
    $J( "span#sfdd" ).click(function () {
        st=3;
        if(gpfd3.style.display=='none'){
			gpfd3.style.display='';
		}else{
			document.getElementById('myframegpfd3').src="preparedoor.php?st="+st;
			gpfd3.style.display='none';
		}
    });
      
    $J( "span#sfde" ).click(function () {
        st=4;
        if(gpfd4.style.display=='none'){
			//document.getElementById('myframegpfd4').src="preparedoor.php?st="+st;
			gpfd4.style.display='';}
        else{       
			gpfd4.style.display='none';
		}
    });
	
    $J( "span#mp3sfdb" ).click(function () {
        if(showspeciesfd4m.style.display=='none'){
			document.getElementById('myframegpfd4m').src="preparedoor.php?st=5";
			showspeciesfd4m.style.display='';
		}else{        
			showspeciesfd4m.style.display='none';
		}
    });
      
    $J( "span#regulonsfdb" ).click(function () {       
        if(regulonshowspeciesfd.style.display=='none'){
			document.getElementById('myframegpfdregulon').src="preparedoor.php?st=6";
			regulonshowspeciesfd.style.display='';
		}else{
			regulonshowspeciesfd.style.display='none';
		}
    });
	  
	$J('.iframe-full-height').on('load', function(){
		this.style.height=this.contentDocument.body.scrollHeight +'px';
	});

    $J("span#tutoMF").click(function(){
		if(iframe_mf.style.visibility=='hidden'){
			iframe_mf.style.visibility='visible';
		}else{
			iframe_mf.style.visibility='hidden';
		}
	});
	
	$J("span#tutoMS").click(function(){
		if(iframe_ms.style.visibility == 'hidden'){
			iframe_ms.style.visibility = 'visible';
		}else{
			iframe_ms.style.visibility = 'hidden';
		}
	});
	
	$J("span#tutoMC").click(function(){
		if(iframe_mc.style.visibility == 'hidden'){
			iframe_mc.style.visibility = 'visible';
		}else{
			iframe_mc.style.visibility = 'hidden';
		}
	});
	
	$J("span#tutoMP3").click(function(){
		if(iframe_mp3.style.visibility == 'hidden'){
			iframe_mp3.style.visibility = 'visible';
		}else{
			iframe_mp3.style.visibility = 'hidden';
		}
	});
	
	$J("span#tutoRF").click(function(){
		if(iframe_rf.style.visibility == 'hidden'){
			iframe_rf.style.visibility = 'visible';
		}else{
			iframe_rf.style.visibility = 'hidden';
		}
	});
	
    $J( "a#sa1" ).click(function () {
		document.getElementById('sequencef').value=document.getElementById('samplep').value;      
    });
	
    $J( "a#sa2" ).click(function () {
		document.getElementById('sequence1').value=document.getElementById('samplep1').value;     
    });
	
    $J( "a#mp3sa2" ).click(function () {
		document.getElementById('mp3t1c').value=document.getElementById('mp3sample').value;     
    });
	
    $J( "a#sa3" ).click(function () {
		document.getElementById('sequence23').value=document.getElementById('sm1').value;      
    });
	
    $J( "a#sa4" ).click(function () {
		document.getElementById('sequence23').value=document.getElementById('sm2').value;      
    });
	
    $J( "a#sa5" ).click(function () {
		document.getElementById('sequence23').value=document.getElementById('sm3').value;      
    });
	
    $J( "a#sa6" ).click(function () {
		document.getElementById('sequence13').value=document.getElementById('samplepp1').value;      
    });
	
    $J( "span#sa7" ).click(function () {
		document.getElementById('sequence2').value=document.getElementById('samplep1').value;      
    });
	
    $J( "a#sa8" ).click(function () {
		document.getElementById('sequence23c').value=document.getElementById('sm1').value;      
    });
	
    $J( "a#sa9" ).click(function () {
		document.getElementById('sequence13c').value=document.getElementById('samplepp1').value;      
    });
  
    $J( "a#sa10" ).click(function () {
		document.getElementById('sequence23c').value=document.getElementById('sm2').value;      
    });
	
    $J( "a#sa11" ).click(function () {
		document.getElementById('sequence23c').value=document.getElementById('sm3').value;      
    });

	$J( "a#regulonsa2" ).click(function () {
		document.getElementById('regulont1c').value=document.getElementById('regulonSample').value;  
    });
           
    $J( "a#sc1" ).click(function () {
		document.getElementById('sequencef').value="";      
    });
	
    $J( "a#sc2" ).click(function () {
		document.getElementById('sequence1').value="";      
    });
	
    $J( "a#mp3sc2" ).click(function () {
		document.getElementById('mp3t1c').value="";      
    });
        $J( "a.sc3" ).click(function () {
      document.getElementById('sequence23').value="";
      
      });
         $J( "a#sc4" ).click(function () {
     document.getElementById('sequence13').value="";
      
      });
         $J( "span#sc5" ).click(function () {
      document.getElementById('sequence2').value="";
      
      });
       $J( "a.sc6" ).click(function () {
      document.getElementById('sequence23c').value="";
      
      });
       $J( "a#sc7" ).click(function () {
      document.getElementById('sequence13c').value="";
      
      });
      
        $J( "a#regulonsc2" ).click(function () {
       
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


function showdata(aad, jobid = '1'){
	if(aad==0){
		document.getElementById('sequencef').value=myframegpfd0.window.getdatap();    
		gpfd0.style.display='none';
	}
	
    if(aad==1){
		//document.getElementById('sequence1').value=myframegpfd1.window.getdatap();
		
		$.get('data/annotation/' + jobid + '/' + jobid, function(data) {
		   document.getElementById('sequence1').value = data;
		});
	    gpfd1.style.display='none';
	}
	
    if(aad==2){
		document.getElementById('sequence13').value=myframegpfd2.window.getdatap();
	    gpfd2.style.display='none';
	}
	
    if(aad==3){
		document.getElementById('sequence2').value=myframegpfd3.window.getdatap();
	    gpfd3.style.display='none';
	}
     
    if(aad==4){
		document.getElementById('sequence13c').value=myframegpfd4.window.getdatap();
	    gpfd4.style.display='none';
	}
	
    if(aad==5){
		document.getElementById('mp3t1c').value=myframegpfd4m.window.getdatap();
		showspeciesfd4m.style.display='none';
	}

	if(aad==6){
		document.getElementById('regulont1c').value=myframegpfdregulon.window.getdatap();
	    regulonshowspeciesfd.style.display='none';
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
        document.getElementById('orNC').value=ASDL.value;

}   

// validation function for motif finding
function validateForm1(){	
	var flag = true;
	
	var title = []
	var seq = []
	var input_seq = $('textarea#sequencef').val().split(">")
    for (var i = 1; i < input_seq.length; i ++) {
    	title_seq = input_seq[i].trim().split("\n")
        title.push(title_seq[0].length)
        seq.push(title_seq[1].length) 
    }
	
	if (Math.max.apply(Math, title) > 200) {
		$.fancybox({
			maxWidth	: 300,
			maxHeight	: 120,
			fitToView	: false,
			width		: '70%',
			height		: '70%',
			autoSize	: false,
			closeClick	: false,
			openEffect	: 'none',
			closeEffect	: 'none',
			href        : '#warnTitleLength'
		});
		flag = false;
	}
	
	if (Math.min.apply(Math, seq) < parseInt($("input#max").val())) {
		$.fancybox({
			maxWidth	: 300,
			maxHeight	: 120,
			fitToView	: false,
			width		: '70%',
			height		: '70%',
			autoSize	: false,
			closeClick	: false,
			openEffect	: 'none',
			closeEffect	: 'none',
			href        : '#warnSeqMotif'
		});
		flag = false;
	}
	
	if (Math.max.apply(Math, seq) > 5000) {
		$.fancybox({
			maxWidth	: 300,
			maxHeight	: 120,
			fitToView	: false,
			width		: '70%',
			height		: '70%',
			autoSize	: false,
			closeClick	: false,
			openEffect	: 'none',
			closeEffect	: 'none',
			href        : '#warnSeqLeng'
		});
		flag = false;
	}
	
	if($('textarea#sequencef').val().length == 0 && $("input#fnafile").val().length == 0){	
		$.fancybox({
			maxWidth	: 300,
			maxHeight	: 120,
			fitToView	: false,
			width		: '70%',
			height		: '70%',
			autoSize	: false,
			closeClick	: false,
			openEffect	: 'none',
			closeEffect	: 'none',
			href        : '#warnQuerSeq'
		});
		flag = false;
	}
	
	if(parseInt($("input#min").val()) > parseInt($("input#max").val()) && $("input#fnafile").val().length == 0){
		$.fancybox({
			maxWidth	: 300,
			maxHeight	: 120,
			fitToView	: false,
			width		: '70%',
			height		: '70%',
			autoSize	: false,
			closeClick	: false,
			openEffect	: 'none',
			closeEffect	: 'none',
			href        : '#warnMotifLeng'
		});
		flag = false;
	}

	if(($('textarea#sequencef').val().split(">").length - 1) < 3&& $("input#fnafile").val().length == 0){
		$.fancybox({
			maxWidth	: 300,
			maxHeight	: 120,
			fitToView	: false,
			width		: '70%',
			height		: '70%',
			autoSize	: false,
			closeClick	: false,
			openEffect	: 'none',
			closeEffect	: 'none',
			href        : '#warnSeqNum'
		});
		flag = false;
	}
	
	if($("input#fnafile").val().length > 0){
		flag = true;
	}
	return flag;
}

// Validation for motif scan
function validateForm2() {
	var flag = true;
	if ($("textarea#sequence23").val().length == 0 && $("input#fnafile4").val().length == 0) {
		$.fancybox({
			maxWidth	: 300,
			maxHeight	: 120,
			fitToView	: false,
			width		: '70%',
			height		: '70%',
			autoSize	: false,
			closeClick	: false,
			openEffect	: 'none',
			closeEffect	: 'none',
			href        : '#warnQuerMotif'
		});
		flag = false;
	}
	if ($("textarea#sequence13").val().length == 0 && $("input#tgfile").val().length == 0) {
		$.fancybox({
			maxWidth	: 300,
			maxHeight	: 120,
			fitToView	: false,
			width		: '70%',
			height		: '70%',
			autoSize	: false,
			closeClick	: false,
			openEffect	: 'none',
			closeEffect	: 'none',
			href        : '#warnQuerSeq'
		});
		flag = false;
	}
	return flag;
}

// Validation for motif compare
function validateForm3() {
	var flag = true;
	if ($("textarea#sequence23c").val().length == 0 && $("input#fnafile3").val().length == 0) {
		$.fancybox({
			maxWidth	: 300,
			maxHeight	: 120,
			fitToView	: false,
			width		: '70%',
			height		: '70%',
			autoSize	: false,
			closeClick	: false,
			openEffect	: 'none',
			closeEffect	: 'none',
			href        : '#warnQuerMotif'
		});
		flag = false;
	}
	return flag;
}

// Validation for MP3
function validateForm4() {
	var flag = true;
	if ($("textarea#mp3t1c").val().length == 0 && $("input#tgfilem4").val().length == 0) {
		$.fancybox({
			maxWidth	: 300,
			maxHeight	: 120,
			fitToView	: false,
			width		: '70%',
			height		: '70%',
			autoSize	: false,
			closeClick	: false,
			openEffect	: 'none',
			closeEffect	: 'none',
			href        : '#warnQuerSeq'
		});
		flag = false;
	}
	return flag;
}

// Validation for regulon finding
function validateForm5 () {
	var flag = true;
	if ($("textarea#regulont1c").val().length == 0 && $("input#tgfiler4").val().length == 0) {
		$.fancybox({
			maxWidth	: 300,
			maxHeight	: 120,
			fitToView	: false,
			width		: '70%',
			height		: '70%',
			autoSize	: false,
			closeClick	: false,
			openEffect	: 'none',
			closeEffect	: 'none',
			href        : '#warnSpecGene'
		});
		flag = false;
	}
	return flag;
}

// Validation for search function (i.e., the search bar on homepage)
function valiSearForm() {		
	var flag = true;
	var searVal = $("input#idSearch").val().trim();		
	if (searVal.length == 0) {
		window.location.href = "index.php";
		flag = false;
	} 
	/*else if (!(/^\d{13,14}[fscmg]$/.test(searVal))) {		
		var my_json;		
		$.getJSON("docs/search/search.json", function(json){
			my_json = json;
			if (my_json.indexOf(searVal) < 0) {	
				flag = false;
				alert("Please input valid query items based on our seggestions");								
			}
		});				
	}*/
	return flag;
}