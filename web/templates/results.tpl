{{extends file="base.tpl"}}
{{block name="extra_js"}}

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
   <script>
  $(document).ready(function () {
  $('#motiftable').DataTable({
	"order": [[ 3, "asc" ]]
  });
  $('.dataTables_length').addClass('bs-select');
});
   	$(document).ready(function() {
    $('.collapse').on('show.bs.collapse', function() {
        var id = $(this).attr('id');
        $('a[href="#' + id + '"]').closest('.panel-heading').addClass('active-faq');
        $('a[href="#' + id + '"] .panel-title span').html('<i class="glyphicon glyphicon-minus"></i>');
    });
    $('.collapse').on('hide.bs.collapse', function() {
        var id = $(this).attr('id');
        $('a[href="#' + id + '"]').closest('.panel-heading').removeClass('active-faq');
        $('a[href="#' + id + '"] .panel-title span').html('<i class="glyphicon glyphicon-plus"></i>');
    });
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
      <div class="container">
         <div class="flatPanel panel panel-primary">
            <div class="flatPanel panel-heading">job ID: 20181004132017f</div>
            <div class="panel-body">
               <div class="flatPanel panel panel-default">
                  <div class="panel-body">
                     <div class="col-md-12 col-sm-12">
                        <div class="form-group col-md-6 col-sm-6">
                           <label for="reportsList">Species: Human</label>
                        </div>
                        <div class="form-group col-md-6 col-sm-6">
                           <label>Number of Cells: #</label>
                        </div>
                        <div class="form-group col-md-6 col-sm-6">
                           <label>Number of Genes: #</label>
                        </div>
                        <div class="form-group col-md-6 col-sm-6">
                           <label>Number of Filtered Genes: #</label>
                        </div>
                        <div class="form-group col-md-6 col-sm-6">
                           <label>Filtering Rate: #%</label>
                        </div>
                        <div class="form-group col-md-6 col-sm-6">
                           <label>Number of Predicted Cell Types: #</label>
                        </div>
                        <div class="form-group col-md-6 col-sm-6">
                           <label>Cell Label: #</label>
                        </div>
                        <div class="form-group col-md-6 col-sm-6">
                           <label>Total Biclusters: #</label>
                        </div>
                        <div class="form-group col-md-6 col-sm-6">
                           <label>Number of Regulons: #</label>
                        </div>
                        <div class="form-group col-md-6 col-sm-6">
                           <label>Number of Complex Regulons: #</label>
                        </div>
                     </div>
                  </div>
               </div>
               <div class="row">
                  <div class="col-md-12">
                     <div class="panel with-nav-tabs panel-default">
                        <div class="panel-heading">
                           <ul class="nav nav-tabs">
                              <li class="active"><a href="#tab1default" data-toggle="tab">Cell Type Prediction</a></li>
                              <li><a href="#tab2default" data-toggle="tab">CTS-Regulon</a></li>
                              <li><a href="#tab3default" data-toggle="tab">CTS-Complex Regulon</a></li>
                              <li><a href="#tab4default" data-toggle="tab">Downloads</a></li>
                           </ul>
                        </div>
                        <div class="panel-body">
                           <div class="tab-content">
                              <div class="tab-pane fade in active" id="tab1default">
                                 <!--Table-->
                                 <table id="tablePreview" class="table">
                                    <!--Table head-->
                                    <thead>
                                       <tr>
                                          <th></th>
                                          <th></th>
                                          <th></th>
                                          <th></th>
                                          <th></th>
                                          <th></th>
                                          <th></th>
                                       </tr>
                                    </thead>
                                    <!--Table head-->
                                    <!--Table body-->
                                    <tbody>
                                       <tr>
                                          <td><strong>Predicted Cell Type</strong></td>
                                          <td>1</td>
                                          <td>2</td>
                                          <td>3</td>
                                          <td>4</td>
                                          <td>5</td>
                                          <td>6</td>
                                          <td>7</td>
                                       </tr>
                                       <tr>
                                          <td><strong>Cell Number</strong></td>
                                          <td>3</td>
                                          <td>3</td>
                                          <td>6</td>
                                          <td>12</td>
                                          <td>20</td>
                                          <td>16</td>
                                          <td>30</td>
                                       </tr>
                                    </tbody>
                                    <!--Table body-->
                                 </table>
                                 <!--Table-->
                                 <table id="tablePreview" class="table">
                                    <!--Table head-->
                                    <thead>
                                       <tr>
                                          <th>ARI</th>
                                          <th>FMI</th>
                                          <th>JI</th>
                                          <th>F-score</th>
                                          <th>Purity</th>
                                          <th>Entropy</th>
                                          <th>NMI</th>
                                          <th>Acc</th>
                                          <th>FPR</th>
                                          <th>Precision</th>
                                          <th>Recall</th>
                                          <th>MCC</th>
                                       </tr>
                                    </thead>
                                    <!--Table head-->
                                    <!--Table body-->
                                    <tbody>
                                       <tr>
                                          <td>0.6549</td>
                                          <td>0.7631</td>
                                          <td>0.7422</td>
                                          <td>0.85</td>
                                          <td>0.5</td>
                                          <td>0.5</td>
                                          <td>0.5</td>
                                          <td>0.5</td>
                                          <td>0.5</td>
                                          <td>0.5</td>
                                          <td>0.5</td>
                                          <td>0.5</td>
                                       </tr>
                                    </tbody>
                                    <!--Table body-->
                                 </table>
                                 <div class="CT-result-img">
                                    <div class="col-sm-12">
                                       <h3 style="text-align:center">Silhoutte Score</h3>
                                       <a href="data/{{$jobid}}/img/01.png" target="_blank"><img src="data/{{$jobid}}/img/01.png" style="margin:auto;display:block"></a> 
                                    </div>
                                    <div class="col-sm-6">
                                       <h3 style="text-align:center">Sankey Plot</h3>
                                       <a href="data/{{$jobid}}/img/02.png" target="_blank"><img src="data/{{$jobid}}/img/02.png" style="margin:auto;display:block"></a> 
                                    </div>
                                    <div class="col-sm-6">
                                       <h3 style="text-align:center">ROC Plot</h3>
                                       <a href="data/{{$jobid}}/img/03.jpg" target="_blank"><img src="data/{{$jobid}}/img/03.jpg" style="margin:auto;display:block"></a> 
                                    </div>
                                 </div>
                              </div>
							  
                              <div class="tab-pane fade" id="tab2default">
							  
  <div class="container">   
    <div class="row">
        <div class="col-md-11">
            <!-- Nav tabs category -->
            <ul class="nav nav-tabs faq-cat-tabs">
                <li class="active"><a href="#faq-cat-1" data-toggle="tab">CT 1</a></li>
                <li><a href="#faq-cat-2" data-toggle="tab">CT 2</a></li>
				 <li><a href="#faq-cat-3" data-toggle="tab">CT 3</a></li>
                <!--<li><a href="#faq-cat-4" data-toggle="tab">CT 4</a></li>
				<li><a href="#faq-cat-5" data-toggle="tab">CT 5</a></li>
                <li><a href="#faq-cat-6" data-toggle="tab">CT 6</a></li>
				<li><a href="#faq-cat-7" data-toggle="tab">CT 7</a></li>-->
            </ul>
    
            <!-- Tab panes -->
            <div class="tab-content faq-cat-content">
                <div class="tab-pane active in fade" id="faq-cat-1">
                    <div class="panel-group" id="accordion-cat-1">
                        <div class="panel panel-default panel-faq">
                            <div class="panel-heading">
                                <a data-toggle="collapse" data-parent="#accordion-cat-1" href="#faq-cat-1-sub-1">
                                    <h4 class="panel-title">
                                        Regulon 1
                                        <span class="pull-right"><i class="glyphicon glyphicon-plus"></i></span>
                                    </h4>
                                </a>
                            </div>
                            <div id="faq-cat-1-sub-1" class="panel-collapse collapse">
                                <div class="panel-body">
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
																  <br />
																  <hr />
																  <br />
																  <table id="motiftable" class="table table-striped table-bordered table-sm" cellspacing="0" width="100%">
                                                                              <thead>
                                                                                 <tr>
                                                                                    <th>Motif logo</th>
                                                                                    <th>Length</th>
                                                                                    <th>Pvalue</th>
                                                                                    <th>Number of Motifs</th>
                                                                                    <th>Number of Genes &nbsp;&nbsp;<img src='static/images/que.png' title="The motif instances are identified with our P-value framework." style="position:relative;padding-top:0px;height:15px;" /></th>
                                                                                 </tr>
                                                                              </thead>
                                                                              <tbody>
																			   {{section name=sec1 loop=$annotation}}
                                                                                 <tr>
                                                                                    <td>
                                                                                       <img onerror="this.src='data/{{$jobid}}/{{$jobid}}{{$annotation[sec1].Motifname}}.png'; "src="data/{{$jobid}}/{{$jobid}}{{$annotation[sec1].Motifname}}.png"  style="width:160px;cursor:pointer;" title="more details"/>  <br/>
                                                                                       <span style="font-size:16pt;">{{$annotation[sec1].Motifname}}</span></a>
                                                                                    </td>
                                                                                    <td>{{$annotation[sec1].Motiflength}}</td>
                                                                                    <td style="white-space:nowrap;">{{$annotation[sec1].MotifPvalue}}</td>
                                                                                    <td>{{$annotation[sec1].Motifnumber}}</td>
                                                                                    <td align="left" >  
                                                                                       For total number of genes
                                                                                    </td>
                                                                                 </tr>
																				<tr>
																																								 
																				 
																				</tr>
																			  {{/section}}
                                                                              </tbody>
                                                                        </table>
</div>
                            </div>
                        </div>
                        <div class="panel panel-default panel-faq">
                            <div class="panel-heading">
                                <a data-toggle="collapse" data-parent="#accordion-cat-1" href="#faq-cat-1-sub-2">
                                    <h4 class="panel-title">
                                        Regulon 2
                                        <span class="pull-right"><i class="glyphicon glyphicon-plus"></i></span>
                                    </h4>
                                </a>
                            </div>
                            <div id="faq-cat-1-sub-2" class="panel-collapse collapse">
                                <div class="panel-body">
                                   </div>
                            </div>
                        </div>
                    </div>
                </div>
				
				<div class="tab-pane fade" id="faq-cat-2">
                    <div class="panel-group" id="accordion-cat-2">
                        <div class="panel panel-default panel-faq">
                            <div class="panel-heading">
                                <a data-toggle="collapse" data-parent="#accordion-cat-2" href="#faq-cat-2-sub-1">
                                    <h4 class="panel-title">
                                        Regulon#1 For CT2
                                        <span class="pull-right"><i class="glyphicon glyphicon-plus"></i></span>
                                    </h4>
                                </a>
                            </div>
                            <div id="faq-cat-2-sub-1" class="panel-collapse collapse">
                                <div class="panel-body">
                                    test Regulon#1 For CT2</div>
                            </div>
                        </div>
                        <div class="panel panel-default panel-faq">
                            <div class="panel-heading">
                                <a data-toggle="collapse" data-parent="#accordion-cat-2" href="#faq-cat-2-sub-2">
                                    <h4 class="panel-title">
                                        Regulon#2 For CT2
                                        <span class="pull-right"><i class="glyphicon glyphicon-plus"></i></span>
                                    </h4>
                                </a>
                            </div>
                            <div id="faq-cat-2-sub-2" class="panel-collapse collapse">
                                <div class="panel-body">
                                    test Regulon#2 For CT2</div>
                            </div>
                        </div>
                    </div>
                </div>
				<div class="tab-pane fade" id="faq-cat-3">
                    <div class="panel-group" id="accordion-cat-3">
                        <div class="panel panel-default panel-faq">
                            <div class="panel-heading">
                                <a data-toggle="collapse" data-parent="#accordion-cat-3" href="#faq-cat-3-sub-1">
                                    <h4 class="panel-title">
                                        Regulon#1 For CT3
                                        <span class="pull-right"><i class="glyphicon glyphicon-plus"></i></span>
                                    </h4>
                                </a>
                            </div>
                            <div id="faq-cat-3-sub-1" class="panel-collapse collapse">
                                <div class="panel-body">
                                    test Regulon#1 For CT3 </div>
                            </div>
                        </div>
                        <div class="panel panel-default panel-faq">
                            <div class="panel-heading">
                                <a data-toggle="collapse" data-parent="#accordion-cat-3" href="#faq-cat-3-sub-2">
                                    <h4 class="panel-title">
                                        Regulon#2 For CT3
                                        <span class="pull-right"><i class="glyphicon glyphicon-plus"></i></span>
                                    </h4>
                                </a>
                            </div>
                            <div id="faq-cat-3-sub-2" class="panel-collapse collapse">
                                <div class="panel-body">
                                    test Regulon#2 For CT3</div>
                            </div>
                        </div>
                    </div>
                </div>					
            </div>
          </div>
        </div>
    </div>
							  </div>
								        
                              <div class="tab-pane fade" id="tab3default">Default 3</div>
                              <div class="tab-pane fade" id="tab4default">
                                 <div class="container">
                                    <div class="row">
                                       <div class="col-12 col-md-12">
                                          <button type="button" class="btn btn-success" data-toggle="collapse" 
                                             data-target="#{{$annotation[sec1].Motifname}}_gene">Download All Files
                                          </button>
                                       </div>
                                       <br><br>
                                       <div class="col-12 col-md-12">
                                          <button type="button" class="btn btn-success" data-toggle="collapse" 
                                             data-target="#{{$annotation[sec1].Motifname}}_gene">Filtered Expression Matrix
                                          </button>
                                          <button type="button" class="btn btn-success" data-toggle="collapse" 
                                             data-target="#{{$annotation[sec1].Motifname}}_gene">Bicluster Matrices
                                          </button>
                                          <button type="button" class="btn btn-success" data-toggle="collapse" 
                                             data-target="#{{$annotation[sec1].Motifname}}_gene">CTS-Biclusters
                                          </button>
                                          <button type="button" class="btn btn-success" data-toggle="collapse" 
                                             data-target="#{{$annotation[sec1].Motifname}}_gene">Cell type prediction
                                          </button>
                                          <button type="button" class="btn btn-success" data-toggle="collapse" 
                                             data-target="#{{$annotation[sec1].Motifname}}_gene">CTS-Regulon
                                          </button>
                                          <button type="button" class="btn btn-success" data-toggle="collapse" 
                                             data-target="#{{$annotation[sec1].Motifname}}_gene">CTS-Complex Regulon
                                          </button>
                                          <button type="button" class="btn btn-success" data-toggle="collapse" 
                                             data-target="#{{$annotation[sec1].Motifname}}_gene">Final Report
                                          </button>								
                                       </div>
                                    </div>
                                 </div>
                              </div>
                              <div class="tab-pane fade" id="tab5default">Default 5</div>
                           </div>
                        </div>
                     </div>
                  </div>
               </div>
            </div>
         </div>
      </div>
   </div>
</main>
{{/block}}