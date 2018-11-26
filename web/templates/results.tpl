{{extends file="base.tpl"}}

{{block name="extra_js"}}
<script type="text/javascript">
    var $J = jQuery.noConflict();
    var tt=0;   
              jQuery.extend( jQuery.fn.dataTableExt.oSort, {
                                       "scientific-pre": function ( a ) {
                                         var a = a.replace(/<(?:.|\s)*?>/g, "");
                                        return parseFloat(a);},
                                        "scientific-asc": function ( a, b ) {
                                        return ((a < b) ? -1 : ((a > b) ? 1 : 0));},
                                        "scientific-desc": function ( a, b ) {
                                        return ((a < b) ? 1 : ((a > b) ? -1 : 0));},
                                        "num-pre": function ( a ) {
                                         var a = a.replace(/<(?:.|\s)*?>/g, "");
                                        return parseInt(a);},
                                        "num-asc": function ( a, b ) {
                                        return ((a < b) ? -1 : ((a > b) ? 1 : 0));},
                                        "num-desc": function ( a, b ) {
                                        return ((a < b) ? 1 : ((a > b) ? -1 : 0));}
                             } );  
                             
  function eventFired( type ) {
         $J("input#SelectAll").val("0");
         $J("input#SelectAll").prop('checked',false); 
       }      
        $J(document).ready(function() {
           $J("div#tabs").tabs({
          fx : { opacity: 'toggle', duration : 'fast' },
        });
      
         var sy=$J("#sy").val();
          var table1; 
            if(sy=="2")
            {table1=$J("table#datat").bind('page',function () {eventFired( 'Page' );}).dataTable({
            "bJQueryUI": true, "sPaginationType": "full_numbers", "iDisplayLength": 10,			
            "bProcessing" : false, "bServerSide": false,
            "aLengthMenu": [[10, 20, -1], [10, 20, "All"]],
            "aaSorting": [[ 3, "asc" ]],
            "aoColumns": [
		                	 {"bSortable": false} ,
			                 {"bSortable": false} ,
			                 { "sType": "num" },
			               { "sType": "scientific" },
                      { "sType": "scientific" },
		                  { "sType": "num" },
		                    {"bSortable": false}
	                      	],
            "oLanguage" : { 
              "sSearch" : "Search in table:",
              "sLoadingRecords" : "Loading data from server ... <img src='static/images/busy.gif' />"
            }
        }); }
        else {
              table1=$J("table#datan").bind('page',function () {eventFired( 'Page' );}).dataTable({
            "bJQueryUI": true, "sPaginationType": "full_numbers", "iDisplayLength": 10,
            "bProcessing" : false, "bServerSide": false,
            "aLengthMenu": [[10, 20, -1], [10, 20, "All"]],
            "aaSorting": [[ 3, "asc" ]],
            "aoColumns": [
		                	 {"bSortable": false} ,
			                 {"bSortable": false} ,
			                  { "sType": "num" },
			               { "sType": "scientific" },
		                   { "sType": "num" },
		                    {"bSortable": false}
	                      	],
            "oLanguage" : { 
              "sSearch" : "Search in table:",
              "sLoadingRecords" : "Loading data from server ... <img src='static/images/busy.gif' />"
            }
        });
        }
           
          $J("input#SelectAll").click( function(){
        
    if( $J(this).val()=="0"){
      
      $J(":input:checkbox.CLASS").prop('checked',true);
       $J(this).val("1");
  } else {
       
      $J(":input:checkbox.CLASS").prop('checked',false);
       $J(this).val("0");
     
  }
 
});
		var vv=$J("#mh").val();
		document.getElementById('id_keyword').value=vv;
        $J("input#s").unbind("click"); 
        $J("input#s").click(function (){ 		
			var $J = jQuery.noConflict();
			var vv=$J("#mh").val();
			var sData = table1.$('input').serialize();
			if(sData!=""){
				$J("#content").html("<div style=\"text-align: center;\"> <p> <img src=\"static/images/busy.gif\" /> <br/></p><p>Your request is received.<br/>Please wait a few seconds. </p></div>");
				$J.post("motif_scan_button.php?jobid="+vv,{check:sData},function(data){ window.location.href="annotate.php?jobid="+vv+"&do=s#tabs-2";},"html"); }
			else
          {alert("Please select motifs by checkbox!");
          }
					return false;
        }
        );
         $J("input#c").unbind("click"); 
          $J("input#c").click(function ()
        {  var $J = jQuery.noConflict();
					var vv=$J("#mh").val();
         // var sData=$J("#frm1").serialize();
          var sData = table1.$('input').serialize();
          if(sData!=""){			
			$J("#content").html("<div style=\"text-align: center;\"> <p> <img src=\"static/images/busy.gif\" /> <br/></p><p>Your request is received.<br/>Please wait a few seconds. </p></div>");
			$J.post("motif_compare_button.php?jobid="+vv,{check:sData},function(data){ window.location.href="annotate.php?jobid="+vv+"&from=cf&do=c#tabs-3";},"html");}
          else
          {alert("Please select motifs by checkbox!");
          }
					return false;
        }
        );
          $J("input#a").unbind("click"); 
          $J("input#a").click(function ()
        {  var $J = jQuery.noConflict();
					var vv=$J("#mh").val();
   
          var sData = table1.$('input').serialize();
           if(sData!="")
			  	{$J("#content").html("<div style=\"text-align: center;\"> <p> <img src=\"static/images/busy.gif\" /> <br/></p><p>Your request is received.<br/>Please wait a few seconds. </p></div>");
					$J.post("motif_annotation_button.php?jobid="+vv,{check:sData},function(data){ window.location.href="motif_annotation_annotation.php?"+data;},"text");}
           else
          {alert("Please select motifs by checkbox!");
          }
					return false;
        }
        );
        
           $J("input#tu").unbind("click"); 
          $J("input#tu").click(function ()
        {  var $J = jQuery.noConflict();
					var vv=$J("#mh").val();
   
          var sData = table1.$('input').serialize();
           if(sData!="")
			  	{ 
          $J("#content").html("<div style=\"text-align: center;\"> <p> <img src=\"static/images/busy.gif\" /> <br/></p><p>Your request is received.<br/>Please wait a few seconds. </p></div>");
					$J.post("motif_trans_button.php?jobid="+vv,{check:sData},function(data){ window.location.href="showtrans.php?jobid="+vv;},"text");}
           else
          {alert("Please select motifs by checkbox!");
          }
					return false;
        }
        );
 
      
       

   });
 
    </script>
   
{{/block}}

{{block name="extra_style"}}
.dataTables_wrapper { min-height: 0;width:100%; }
th {text-align:center}
div#content { min-height: 400px; }
{{/block}}

{{block name="main"}}
<main role="main" class="container">
<div id="content">
     <input type="hidden" id="mh" value="{{$jobid}}"/>
     <input type="hidden" id="sy" value="{{$sy}}"/>
	 <div class="container" id="input_form">
  <div class="row">
    <div class="col-sm-12">
      <div class="panel panel-default">
        <div class="panel-heading">
          <!-- <h3 class="panel-title">Datasets ranking by regulatory potential on your interested gene or tanscript</h3> -->
<!--          <h3 class="panel-title">What regulators are targeting your gene?</h3> -->
            <h3 class="panel-title">What factors regulate your gene of interest?</h3>
        </div>
        <div class="panel-body">
          <div class="container">
            <form class="form-group" method="get">
              <div class="row">
                <div class="col-sm-1"></div>
                <div class="col-sm-4">
                  <div class="form-group">
                    <label class="row col-form-label">
                      <label for="species">Species</label>
                    </label>
                    <div class="row">
                      <select class="form-control" name="specie" id="species">
                        <option selected="" value="hg38">Human hg38</option>
                        <option value="mm10">Mouse mm10</option>
                      </select>
                    </div>
                  </div>
                  <div class="form-group">
                    <label class="row col-form-label">
                      <label for="gene">Gene or transcript</label>
                    </label>
                    <div class="row">
                      <input class="form-control" id="keyword" name="keyword" placeholder="GAPDH or NM_001289746" required="">
                    </div>
                  </div>
                </div>
                <div class="col-sm-1"></div>
                <div class="col-sm-4">
                  <div class="form-group">
                    <label class="row col-form-label">
                    <label for="tdata">Data type in Cistrome</label>
                    </label>
                    <div class="row">
                      <select class="form-control" name="factor" id="factor">
                        <option selected="" value="factor">Transcription factor, chromatin regulator</option>
                        <option value="hmca">Histone mark and variants, chromatin accessbility</option>
                      </select>
                    </div>
                    <label class="row col-form-label">
                      <label>The distance to transcription start site (peaks within this distance will be summarized)</label>
                    </label>
                  <div class="form-group">
                    <div class="row">
                      <select class="form-control" name="distance" id="distance">
                        <option value="1k">1kb</option>
                        <option value="10k">10kb</option>
                        <option selected="" value="100k">100kb</option>
                      </select>
                    </div>
                  </div>
                </div>
              </div>
              </div>
              <div class="row">
                <div class="col-sm-5"></div>
                <div class="col-sm-2">
                  <input class="btn btn-primary" type="submit" value="Submit" id="rpInput">
                </div>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
<div class="bs-example3">
    <div class="panel-group" id="accordion3">
        <div class="panel panel-default">
            <div class="panel-heading">
                <h4 class="panel-title">
                    <a data-toggle="collapse" data-parent="#accordion" href="#collapseThree3">Cell type 1</a>
                </h4>
            </div>
            <div id="collapseThree3" class="panel-collapse collapse">
            <div class="panel-body">
            
  {{if $status == "Done"}}
      
  
  <div class="result" border="1">

           {{if $sy==2}} 	 
          <span style="position:relative;"><a href="data/{{$jobid}}/{{$jobid}}.txt" target="_blank" >Download input</a>
           <a href="data/{{$jobid}}/{{$jobid}}bkg" target="_blank" >Download background</a>
           <a href="data/{{$jobid}}/{{$jobid}}.motifinfo" target="_blank" >Download result</a></span>
            {{else}}
          <span style="position:relative;"><a href="data/{{$jobid}}/{{$jobid}}.txt" target="_blank" >Download input</a>
           <a href="data/{{$jobid}}/{{$jobid}}.motifinfo" target="_blank" >Download result</a></span>
           {{/if}}
    </div>  
  <form id="frm1" name="form">
      <div class="section2" >
{{section name=sec1 loop=$annotation}}
<button type="button" class="btn btn-primary" data-toggle="collapse" 
    data-target="#{{$annotation[sec1].Motifname}}">
    {{$annotation[sec1].Motifname}}
</button>

<div id="{{$annotation[sec1].Motifname}}" class="collapse">
     <table class="motif_table" id="datan" >
       
		 <thead>
            <tr>
               <th>Motif logo</th>
               <th>Length</th>
               <th>Pvalue</th> 
               <th>Number</th>              
                <th>Genes &nbsp;&nbsp;<img src='static/images/que.png' title="The motif instances are identified with our P-value framework." style="position:relative;padding-top:0px;height:15px;" /></th>
             </tr> 
        </thead>
          
          <tbody>
            
                <tr  align="middle">
                <td>
                <br/>
                <img onerror="this.src='data/{{$jobid}}/{{$jobid}}{{$annotation[sec1].Motifname}}.png'; "src="data/{{$jobid}}/{{$jobid}}{{$annotation[sec1].Motifname}}.png"  style="width:200px;cursor:pointer;" title="more details"/>  <br/>
                <span style="font-size:16pt;">{{$annotation[sec1].Motifname}}</span></a>
                </td>
                <td><br/><br/><br/><br/><br/><br/>{{$annotation[sec1].Motiflength}}</td>
                <td style="white-space:nowrap;"><br/><br/><br/><br/><br/><br/>{{$annotation[sec1].MotifPvalue}}</td>
                <td><br/><br/><br/><br/><br/><br/>{{$annotation[sec1].Motifnumber}}</td> 
                <td align="left" >  
                                  
								  <button type="button" class="btn btn-success" data-toggle="collapse" 
									data-target="#{{$annotation[sec1].Motifname}}_gene">
								Show {{$annotation[sec1].Motifname}} gene
									</button>
                                   
                </td>
	           </tr>
	    
          
         </tbody>
    </table> 
	
								<div id="{{$annotation[sec1].Motifname}}_gene" class="collapse">
								<div style="height:300px;overflow-y:scroll;">
                                  <table>
	                                 <tr>
	                                      <th>Info&nbsp;&nbsp;</th>
										  <th>Weight&nbsp;&nbsp;</th>
	                                      <th>Start&nbsp;&nbsp;</th>
	                                      <th>End&nbsp;&nbsp;</th>
	                                      <th>Motif&nbsp;&nbsp;</th>
	                                      <th>Score&nbsp;&nbsp;</th>
	                                      <th>Annotation&nbsp;&nbsp;</th>
	                                 </tr>
	                                
                                  {{section name=sec2 loop=$annotation[sec1].Motifs}}
                                        {{if $annotation[sec1].Motifs[sec2].red==1}}
                                         <tr style="background-color:white;">
										 <td>{{$annotation[sec1].Motifs[sec2].Info}}</td>
                                         <td>{{$annotation[sec1].Motifs[sec2].Seq}}</td>
                                         <td>{{$annotation[sec1].Motifs[sec2].start}}</td>
                                         <td>{{$annotation[sec1].Motifs[sec2].end}}</td>
                                         <td>{{$annotation[sec1].Motifs[sec2].Motif}}</td>
                                         <td>{{$annotation[sec1].Motifs[sec2].Score}}</td>
                                         <td>Annotation info</td>
                                         </tr>
                                         {{else}}
                                          <tr style="background-color:white;">
										 <td>{{$annotation[sec1].Motifs[sec2].Info}}</td>
                                         <td>{{$annotation[sec1].Motifs[sec2].Seq}}</td>
                                         <td>{{$annotation[sec1].Motifs[sec2].start}}</td>
                                         <td>{{$annotation[sec1].Motifs[sec2].end}}</td>
                                         <td>{{$annotation[sec1].Motifs[sec2].Motif}}</td>
                                         <td>{{$annotation[sec1].Motifs[sec2].Score}}</td>
                                         <td>Annotation info</td>
                                         </tr>
                                         {{/if}}
                                   {{/section}}
                               
					</table>
							</div> 
							</div>
</div>
{{/section}}
      </div>

</form>
		  <br>
                </div>
            </div>
        </div>
    </div>
</div>


</div>
	{{/if}}
</main>
{{/block}}