{{extends file="base.tpl"}} {{block name="extra_js"}} {{/block}} {{block name="extra_style"}} {{/block}} {{block name="main"}}

<!-- Latest compiled and minified plotly.js JavaScript -->
<script src="https://cdn.plot.ly/plotly-latest.min.js"></script>

<!-- OR use a specific plotly.js release (e.g. version 1.5.0) -->
<script src="https://cdn.plot.ly/plotly-1.5.0.min.js"></script>

<!-- OR an un-minified version is also available -->
<script src="https://cdn.plot.ly/plotly-latest.js" charset="utf-8"></script>
<script>
var flag = [];
$(document).ready(function () {
    $('#tablePreview').DataTable( {
  "searching": false,
  "paging": false,
  "bInfo" : false,
} );
	
	    
	

$("#to_enrichr").click(function (){
                   get_gene_list(1,2);
            });
	  
	  	make_clust_main('data/{{$jobid}}/json/CT1.json','#container-id-1');
	  //flag.push("#container-id-1")
	  function arrayContains(needle, arrhaystack)
		{
    return (arrhaystack.indexOf(needle) > -1);
		}
		
$('a[tabtype="main"]').on('shown.bs.tab', function (e) {

  var json_file = $(e.target).attr("json")
  var root_id = $(e.target).attr("root")
	if (!arrayContains(root_id,flag)){
	make_clust_main(json_file,root_id);
	flag.push(root_id)
	//var element_group = document.getElementsByClassName('row_slider_group');
	//for (i in element_group)
	//	i.style.display='none';
	}
    });		
		
$('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
console.log(flag)
  var json_file = $(e.target).attr("json")
  var root_id = $(e.target).attr("root")
  console.log(!arrayContains(root_id,flag))
	if (!arrayContains(root_id,flag)){
	make_clust(json_file,root_id);
	flag.push(root_id)
	}
    });


});
</script>

<main role="main" class="container" style="min-height: calc(100vh - 182px);">
    <div id="content">
 
        <div class="container">
            <br/>
            <div class="flatPanel panel panel-default" >
                

                    {{if $status == "1"}}
					<div class="flatPanel panel-heading" style="padding: 20px 20px"><strong>Job ID: {{$jobid}}</strong><input style="float:right; "class="btn btn-submit" type="button" value="Download" onClick="javascript:location.href = '/iris3/data/{{$jobid}}/{{$jobid}}.zip';" /></div>
                <div class="panel-body">
                    <div class="row">
                        <div class="col-md-12">
                            <div class="panel with-nav-tabs panel-default">

                                <div class="panel-heading">
                                    <ul class="nav nav-tabs">
                                        <li class="active"><a href="#tab1default" data-toggle="tab">General results</a></li>
                                        <li><a href="#tab2default" data-toggle="tab">Cell Type Prediction</a></li>
                                        <li><a href="#tab3default" data-toggle="tab">Job settings</a></li>
                                    </ul>
                                </div>
                                <div class="panel-body">
                                    <div class="tab-content">
									<div class="tab-pane fade in active" id="tab1default">
                                            <div class="flatPanel panel panel-default">
                        <div class="panel-body">
                            <div class="col-md-12 col-sm-12">
                                <div class="form-group col-md-4 col-sm-4">
                                    <p for="reportsList">Species: {{$species}}</p>
                                </div>
                                <div class="form-group col-md-4 col-sm-4">
                                    <p>Number of cells: {{$total_label}}</p>
                                </div>
                                <div class="form-group col-md-4 col-sm-4">
                                    <p>Number of genes: {{$total_num}}</p>
                                </div>
                                <div class="form-group col-md-4 col-sm-4">
                                    <p>Number of filtered genes: {{$filter_num}}</p>
                                </div>
                                <div class="form-group col-md-4 col-sm-4">
                                    <p>Filtering ratio: {{$filter_rate*100}}%</p>
                                </div>
								{{if $provide_label > 0}}
                                <div class="form-group col-md-4 col-sm-4">
                                    <p>Number of provided cell types: {{$provide_label}}</p>
                                </div>
								{{/if}}
								<div class="form-group col-md-4 col-sm-4">
                                    <p>Number of predicted cell types: {{$predict_label}}</p>
                                </div>
                                <div class="form-group col-md-4 col-sm-4">
                                    <p>Total biclusters: {{$total_bic}}</p>
                                </div>
                                <div class="form-group col-md-4 col-sm-4">
                                    <p>Total CTS-Regulons: {{$total_regulon}}</p>
                                </div>
<!--Table-->
                                            <table id="tablePreview" class="table">
                                                <!--Table head-->
                                                <thead>
                                                    <tr>
                                                        <th>{{if $label_use_sc3 == 'user\'s label'}}
														Provided Cell Type Index
														{{else}}
															Predicted Cell Type Index
														{{/if}}</th>
                                                        {{if $label_use_sc3 == 'user\'s label'}}
															<th>
															Provided Cell Type Labels
															</th>
															{{/if}}
														<th>Number of {{if $label_use_sc3 == 'user\'s label'}}
														Provided
														{{else}}
															Predicted
														{{/if}} Cells</th>
                                                        <th>Number of Predicted Regulons</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
												{{section name=ct_idx start=0 loop=$count_ct}}
													<tr >
															<td style="padding: 0px;">{{$count_ct[ct_idx]}}</td>
															{{if $label_use_sc3 == 'user\'s label'}}
															<td style="padding: 0px;">
															{{$provided_cell[ct_idx]}}
															</td>
															<td style="padding: 0px;">{{$provided_cell_value[ct_idx]}}</td>
															{{else}}
															<td style="padding: 0px;">{{count($silh_x[{{$silh_trace[ct_idx]}}])}}</td>
															{{/if}}
															
															
															
															
															<td style="padding: 0px;">{{$count_regulon_in_ct[ct_idx]}}</td>
                                                    </tr>
													{{/section}}
													<!--
													{{foreach from=$provided_cell key=k item=v}}<td>{{$k}}</td> {{/foreach}}
													
													
													
													{{if $label_use_sc3 == 'user\'s label'}}
													<tr>
															<td><strong>Provided Cell Type Labels</strong></td>
																{{foreach from=$provided_cell key=k item=v}}<td>{{$k}}</td> {{/foreach}}
															</tr>
															{{/if}}
													<tr>
													    <td><strong>Number of {{if $label_use_sc3 == 'user\'s label'}}
														Provided
														{{else}}
															Predicted
														{{/if}} Cells</strong></td>
														{{if $label_use_sc3 == 'user\'s label'}}
															{{foreach from=$provided_cell key=k item=v}}<td>{{$v}}</td> {{/foreach}}
															
														{{else}}
															{{section name=clust loop=$silh_trace}}<td>{{count($silh_x[{{$silh_trace[clust]}}])}}</td> {{/section}}
														{{/if}}
                                                    </tr>
                                                    <tr>
                                                        <td><strong>Number of Predicted Regulons</strong></td>
														{{section name=num_regulon_in_ct start=0 loop=$count_regulon_in_ct}}
															<td>{{$count_regulon_in_ct[num_regulon_in_ct]}}</td>
                                                        {{/section}}
                                                    </tr>
												-->
                                                    
                                                </tbody>
                                            </table>
                            </div>
                        </div>
                    </div>

                                            </div>
                                        
                                        <div class="tab-pane fade " id="tab2default">
										{{if ($ARI  >0)}}
                                             <table id="tablePreview" class="table">
                                                <thead>
                                                    <tr>
                                                        <th>ARI</th>
                                                        <th>RI</th>
                                                        <th>JI</th>
                                                        <th>FMI</th>
                                                        
                                                        <!--<th>Purity</th>
                                                        <th>Entropy</th><th>Accuracy</th> <td>{{$purity}}</td>
                                                        <td>{{$entropy}}</td><td>{{$Accuracy}}</td> -->
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr>
                                                        <td>{{$ARI}}</td>
                                                        <td>{{$RI}}</td>
                                                        <td>{{$JI}}</td>
                                                        <td>{{$FMI}}</td>
                                                       
                                                        
                                                    </tr>
                                                </tbody>
                                            </table>
											
											{{/if}}
											{{if ($saving_plot1  >0)}}
											<div class="col-sm-12">
											<h4 style="text-align:center"> SC3 consensus heatmap<input style="float:right; "class="btn btn-submit" type="button" value="Save consensus heatmap as .emf" onClick="javascript:location.href = 'data/{{$jobid}}/saving_plot1.emf';" /></h4> 
											
											<img style="width:100%"src="data/{{$jobid}}/saving_plot1.jpeg"></img>
											</div>
											{{/if}}
											
                                            <div class="CT-result-img">
                                                <div class="col-sm-12">
												<h4 style="text-align:center;margin-top:50px"> Silhouette score</h4>
                                                    <div id="score_div"></div>
												</div>
                                                <div class="col-sm-12">
												<h4 style="text-align:center;margin-top:50px"> Sankey plot</h4>
                                                    <div id="sankey_div"></div>
												</div>
											</div>
										</div>

                                        <div class="tab-pane fade" id="tab3default">
                                            <div class="flatPanel panel panel-default">
                        <div class="panel-body">
                            <div class="col-md-12 col-sm-12">
                                <div class="form-group col-md-6 col-sm-6">
                                    <p for="reportsList">Allow data storage in our database: {{$if_allowSave}}</p>
                                </div>
                                <div class="form-group col-md-6 col-sm-6">
                                    <p>Gene filtering: {{$is_filter}}</p>
                                </div>
								<div class="form-group col-md-6 col-sm-6">
                                    <p for="reportsList">Consistency level: {{$c_arg}}</p>
                                </div>
                                <div class="form-group col-md-6 col-sm-6">
                                    <p>Max biclusters: {{$o_arg}}</p>
                                </div>
                                <div class="form-group col-md-6 col-sm-6">
                                    <p>Overlap rate: {{$f_arg}}</p>
                                </div>
                                <div class="form-group col-md-6 col-sm-6">
                                    <p>CTS-regulon prediction using {{$label_use_sc3}} and {{$motif_program}}</p>
                                </div>
                                <div class="form-group col-md-6 col-sm-6">
                                    <p>Uploaded files: </p><p>{{$expfile_name}}</p><p>{{$labelfile_name}}</p>
                                </div>
								<div class="form-group col-md-6 col-sm-6"> 
                                    <p>Email: {{$email_line}}</p>
                                </div>
                            </div>
                        </div>
                    </div>
                                        </div>
                                        <div class="tab-pane fade" id="tab5default">Default 5</div>
                                    </div>
                                </div>
                            </div>
                                            <div class="flatPanel panel panel-default">
                        <div class="panel-body">
                            <div class="row" style="">
                                <div class="form-group col-md-12 col-sm-12" style="height:100%">
                                    
									     <ul class="nav nav-tabs" id="myTab" role="tablist">
										                   
														   <!--
															<li class="nav-item">
                                                                <a class="nav-link" id="profile-tab" data-toggle="tab" tabtype="main" href="#main_CT2" json="data/{{$jobid}}/ct2.json" root="#container-id-12" role="tab" aria-controls="profile" aria-selected="false">Cell Type2</a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a class="nav-link" id="contact-tab" data-toggle="tab" tabtype="main" href="#main_CT3" json="data/{{$jobid}}/ct3.json" root="#container-id-13" role="tab" aria-controls="contact" aria-selected="false">Cell Type3</a>
                                                            </li>
															-->
															{{section name=ct_idx start=0 loop=$count_ct}}
															
                                                            <li class="nav-item {{if {{$count_ct[ct_idx]}} eq '1'}}active{{/if}}">
                                                                <a class="nav-link fade in {{if {{$count_ct[ct_idx]}} eq '0'}}active{{/if}}" id="home-tab" data-toggle="tab" tabtype="main" href="#main_CT{{$count_ct[ct_idx]}}" json="data/{{$jobid}}/json/CT{{$count_ct[ct_idx]}}.json" root="#container-id-{{$count_ct[ct_idx]}}" role="tab" aria-controls="home" aria-selected="true">CT{{$count_ct[ct_idx]}}</a>
                                                            </li>
															{{/section}}
															
                                                            
                                                        </ul>
                                                        <div class="tab-content" id="myTabContent">	
														{{section name=ct_idx start=0 loop=$count_ct}}	{{/section}}
														{{foreach from=$regulon_result item=label1 key=sec0}}														
															<div class="tab-pane {{if {{$sec0+1}} eq '1'}}active{{/if}}" id="main_CT{{$sec0+1}}" role="tabpanel">
																<div class="flatPanel panel panel-default">
																			<div class="row" style="">
																			<div class="form-group col-md-12 col-sm-12" style="height:100%">
																			<strong>CTS Cell-Gene-Regulon Heatmap for Cell Type {{$sec0+1}}</strong><br>
																			<a href="/iris3/heatmap.php?jobid={{$jobid}}&file=CT{{$sec0+1}}.json" target="_blank">
                                                                        <button type="button" class="btn btn-submit" data-toggle="collapse" data-target="/iris3/heatmap.php?jobid={{$jobid}}&file=CT{{$sec0+1}}.json">Open in new tab
                                                                        </button>
                                                                    </a>&nbsp;<a href="/iris3/data/{{$jobid}}/{{$jobid}}_CT_{{$sec0+1}}_bic.regulon_gene_name.txt" target="_blank">
                                                                        <button type="button" class="btn btn-submit" data-toggle="collapse" data-target="/html/iris3/data/{{$jobid}}/{{$jobid}}_CT_{{$sec0+1}}_bic.regulon_gene_name.txt">Download CT-{{$sec0+1}} regulon-gene list 
                                                                        </button>
                                                                    </a>
																				<div id="heatmap">
																						<div id='container-id-{{$sec0+1}}' style="height:95%;max-height:95%;max-width:100%;display:block">
																						<h1 class='wait_message'>Please wait ...</h1>
																					</div></div></div></div></div>
<div class="flatPanel panel panel-default">
																			<div class="row" >
																			<div class="form-group col-md-12 col-sm-12" style="height:100%">
																		
																	<table id="motiftable" class="table table-bordered" cellpadding="0" cellspacing="0" width="100%">
                                                                    <thead>
                                                                        <tr>
                                                                        </tr>
                                                                    </thead>
                                                                    <tbody>
                                                                        {{section name=sec1 loop=$regulon_result[$sec0]}}
																		<tr ><td colspan=2 style="font-weight:600;text-align:center">{{$regulon_result[$sec0][sec1][0]}}</td></tr>
																		
                                                                        <tr >
                                                                            <td style="display:inline-block; overflow-y: auto;width:49%;max-height:400px;">
                                                                                <div style="width:100%; font-size:14px;">
																				<table class="table table-bordered table-hover" >
	                                 
	                                
                                  {{section name=sec2 start=1 loop=$regulon_result[$sec0][sec1]}}
                                          <tr >
										  
                                         <td><a  target="_blank" href= "https://www.genecards.org/cgi-bin/carddisp.pl?gene={{$regulon_result[$sec0][sec1][sec2]}}" style="font-size:14px; display: inline-block;">{{$regulon_result[$sec0][sec1][sec2]}}&nbsp;</a></td>
										 									
                                         <td><a  target="_blank" href= "https://www.ensembl.org/id/{{$regulon_id_result[$sec0][sec1][sec2]}}" style="font-size:14px; display: inline-block;">{{$regulon_id_result[$sec0][sec1][sec2]}}&nbsp;</a></td>
										 
										 {{/section}}
                                         </tr>
                                   
                                 </table>
											</div>										
																				

                                                                            </td>
																			<td style="display:inline-block; overflow-y: auto;max-height:400px; border:none;width:49%;" >
																			
                                                                                <div class="col-sm-12">
																				{{section name=sec3  start=1 loop=$regulon_motif_result[$sec0][sec1]}}
																				
																				{{assign var="this_motif" value=","|explode:$regulon_motif_result[$sec0][sec1][sec3]}}
																				
																					<span>{{$regulon_result[$sec0][sec1][0]}}-Motif-{{$smarty.section.sec3.index}}<a href="motif_detail.php?jobid={{$jobid}}&ct={{$this_motif[0]}}&bic={{$this_motif[1]}}&id={{$this_motif[2]}}" target="_blank"><img src="data/{{$jobid}}/logo/ct{{$this_motif[0]}}bic{{$this_motif[1]}}m{{$this_motif[2]}}.fsa.png" style="display:block;margin-left: auto;margin-right: auto;width: 50%;"></a></span>
																					
									<input class="btn btn-submit" type="button" value="JASPAR" onClick="window.open('prepare_tomtom.php?jobid={{$jobid}}&ct={{$this_motif[0]}}&bic={{$this_motif[1]}}&m={{$this_motif[2]}}&db=JASPAR');"  />
									<input class="btn btn-submit" type="button" value="HOCOMOCO" onClick="window.open('prepare_tomtom.php?jobid={{$jobid}}&ct={{$this_motif[0]}}&bic={{$this_motif[1]}}&m={{$this_motif[2]}}&db=HOCOMOCO');"  /><hr>
                                                                                </div>
																				{{/section}}
                                                                            </td>
                                                                        </tr>
																		<tr><td><button type="button" class="btn btn-submit" data-toggle="collapse" id="{{$regulon_result[$sec0][sec1][0]}}" onclick="console.log('{{$regulon_result[$sec0][sec1][0]}}');$('#heatmap-{{$regulon_result[$sec0][sec1][0]}}').show();make_clust('data/{{$jobid}}/json/{{$regulon_result[$sec0][sec1][0]}}.json','#ci-{{$regulon_result[$sec0][sec1][0]}}');flag.push('#ci-{{$regulon_result[$sec0][sec1][0]}}');$('#hide-{{$regulon_result[$sec0][sec1][0]}}').show();$('#{{$regulon_result[$sec0][sec1][0]}}').hide();">Show Heatmap
                                                        </button><button style="display:none;" type="button" class="btn btn-submit" data-toggle="collapse"  id="hide-{{$regulon_result[$sec0][sec1][0]}}" onclick="$('#ci-{{$regulon_result[$sec0][sec1][0]}}').removeAttr('style');$('#ci-{{$regulon_result[$sec0][sec1][0]}}').empty();$('#{{$regulon_result[$sec0][sec1][0]}}').show();$('#hide-{{$regulon_result[$sec0][sec1][0]}}').hide();">Hide Heatmap
                                                        </button>&nbsp;<button type="button" id="enrichr-{{$regulon_result[$sec0][sec1][0]}}" class="btn btn-submit" data-toggle="collapse" onclick="get_gene_list(this)" >Send gene list to EnrichR
                                                        </button></td></tr>
																		<tr >
																		<td colspan=2>
																		
																					<div id="heatmap-{{$regulon_result[$sec0][sec1][0]}}" style="display:none;">
																						<div id='ci-{{$regulon_result[$sec0][sec1][0]}}' style="max-width:100%;display:block">
																						<h1 class='wait_message'>Loading heatmap ...</h1>
																					</div></div>
																		</td>
																		</tr>

                                                                        {{/section}}
                                                                    </tbody>
                                                                </table>

																					
																	</div></div></div>
                                                            </div>	
															{{/foreach}}														
															</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
						</div>
                    </div>
					 </div>
					 </div>
            </div>
					{{elseif $status==="404"}}
					<div class="flatPanel panel-heading" style="padding: 20px 20px"><strong>Job ID: {{$jobid}}</strong></div>
                <div class="panel-body">
					<div style="text-align: left;">
                        <p>Job ID nout found</p>
                    </div>
					</div>
					{{elseif $status==="error"}}
					<div class="flatPanel panel-heading" style="padding: 20px 20px"><strong>Job ID: {{$jobid}}</strong></div>
						<div class="panel-body">
					<div style="text-align: left;">
                        <strong><h3>Sorry, there has been an error.</h3></strong>
						<p>Note that currently we accept human and mouse expression matrix for submission, Each gene measured in the expression dataset should have an identifier listed in the first column, both Gene Symbols (e.g. HSPA9) and Gene IDs (e.g. ENSG00000113013) are allowed. Pleas check our <a href="http://bmbl.sdstate.edu/iris3/tutorial.php#1basics">tutorial</a> for more information. </p>
						<!---
						
						<p>Perhaps you are here because: </p>
						<ul>
						<li> Wrong input file format</li>
						</ul>
						
						--->
						<br>
                    </div>
					
					<strong>Your job settings:</strong><br>
                            <div class="col-md-12 col-sm-12">
                                <div class="form-group col-md-6 col-sm-6">
                                    <p for="reportsList">Allow data storage in our database: {{$if_allowSave}}</p>
                                </div>
                                <div class="form-group col-md-6 col-sm-6">
                                    <p>Gene filtering: {{$is_filter}}</p>
                                </div>
								<div class="form-group col-md-6 col-sm-6">
                                    <p for="reportsList">Consistency level: {{$c_arg}}</p>
                                </div>
                                <div class="form-group col-md-6 col-sm-6">
                                    <p>Max biclusters: {{$o_arg}}</p>
                                </div>
                                <div class="form-group col-md-6 col-sm-6">
                                    <p>Overlap rate: {{$f_arg}}</p>
                                </div>
								<div class="form-group col-md-6 col-sm-6">
                                    <p>CTS-regulon prediction using {{$label_use_sc3}} and {{$motif_program}}</p>
                                </div>
                                <div class="form-group col-md-6 col-sm-6"> 
                                    <p>Uploaded files: </p><p>{{$expfile_name}}</p><p>{{$labelfile_name}}</p>
                                </div>
								<div class="form-group col-md-6 col-sm-6"> 
                                    <p>Email: {{$email_line}}</p>
                                </div>
                                
                                

                            </div>
					</div>
					
                    {{else}} {{block name="meta"}}
					<div class="flatPanel panel-heading" style="padding: 20px 20px"><strong>Job ID: {{$jobid}}</strong></div>
                <div class="panel-body">
                    <META HTTP-EQUIV="REFRESH" CONTENT="15"> {{/block}}

                    <div style="text-align: left;">
                        <div class="flatPanel panel panel-default">
                        <div class="panel-body"><p>

                            <img src="static/images/busy.gif" />
                            <br /> Your request is received now.
                            <br> You can remember your jobid <font color="red"> <strong>{{$jobid}}</strong> </font>
                            <br> Or you can choose to stay at this page, which will be automatically refreshed every <b>15</b> seconds.
                            <br/> Link:&nbsp
                            <a href="{{$LINKPATH}}/iris3/results.php?jobid={{$jobid}}">http://bmbl.sdstate.edu/{{$LINKPATH}}iris3/results.php?jobid={{$jobid}}</a></p>
							
							
							<strong>Job settings:</strong><br>
                            <div class="col-md-12 col-sm-12">
                                <div class="form-group col-md-6 col-sm-6">
                                    <p for="reportsList">Allow data storage in our database: {{$if_allowSave}}</p>
                                </div>
                                <div class="form-group col-md-6 col-sm-6">
                                    <p>Gene filtering: {{$is_filter}}</p>
                                </div>
								<div class="form-group col-md-6 col-sm-6">
                                    <p for="reportsList">Consistency level: {{$c_arg}}</p>
                                </div>
                                <div class="form-group col-md-6 col-sm-6">
                                    <p>Max biclusters: {{$o_arg}}</p>
                                </div>
                                <div class="form-group col-md-6 col-sm-6">
                                    <p>Overlap rate: {{$f_arg}}</p>
                                </div>
								<div class="form-group col-md-6 col-sm-6">
                                    <p>CTS-regulon prediction using {{$label_use_sc3}} and {{$motif_program}}</p>
                                </div>
                                <div class="form-group col-md-6 col-sm-6"> 
                                    <p>Uploaded files: </p><p>{{$expfile_name}}</p><p>{{$labelfile_name}}</p>
                                </div>
								<div class="form-group col-md-6 col-sm-6"> 
                                    <p>Email: {{$email_line}}</p>
                                </div>
                                
                                

                            </div>
                        </div>
                    </div>
                    </div>
					</div>
                    {{/if}}
                </div>
        </div>
    </div>
    <!-- Required JS Libraries -->
	<script src="assets/js/d3.js"></script>
    <script src="assets/js/underscore-min.js"></script>

    <!-- Clustergrammer JS -->
    <script src='assets/js/clustergrammer.js'></script>

    <!-- optional modules -->
    <script src='assets/js/Enrichrgram.js'></script>
    <script src='assets/js/hzome_functions.js'></script>
    <script src='assets/js/send_to_Enrichr.js'></script>

    <!-- make clustergram -->
    <script src='assets/js/load_clustergram.js'></script>

    <script>


{{section name=clust loop=$silh_trace}}
var trace{{$silh_trace[clust]}} = {
  x: [{{section name=idx loop=$silh_x[{{$silh_trace[clust]}}]}} "{{$silh_x[{{$silh_trace[clust]}}][idx]}}",{{/section}}],
  y: [{{section name=idx loop=$silh_y[{{$silh_trace[clust]}}]}} "{{$silh_y[{{$silh_trace[clust]}}][idx]}}",{{/section}}],
  name: '{{$silh_trace[clust]}}',
  type: 'bar'
};

{{/section}}


var score_data = [{{section name=clust loop=$silh_trace}}trace{{$silh_trace[clust]}},  {{/section}}];

		var score_layout = {
		barmode: 'group',
			width:window.innerHeight-20,
            font: {
                size: 12
            },
	"titlefont": {
    "size": 16
	},
        }
		Plotly.react('score_div', score_data, score_layout);
		
		
	function get_gene_list(item){
	match_id = $(item).attr("id").match(/\d+/gm);
	file_path = 'data/'+ {{$jobid}} +'/'+{{$jobid}} + '_CT_'+match_id[0]+'_bic.regulon_gene_name.txt';
	
	$.get(file_path,function(txt){
        var lines = txt.split("\n");
		gene_idx = match_id[1] - 1;
		lines[gene_idx].split("\t").shift().replace(/\t /g, '\n');
		//
		gene_list = lines[gene_idx].split("\t");
		gene_list.shift();
		
		var enrichr_info = {list: gene_list.join("\n"), description: 'Gene list send to '+$(item).attr("id") , popup: true};
	
		//console.log(enrichr_info);
          // defined globally - will improve
          send_to_Enrichr(enrichr_info);
    }); 
	
	}

	function send_to_Enrichr(options) { // http://amp.pharm.mssm.edu/Enrichr/#help
    var defaultOptions = {
    description: "",
    popup: false
  };

  if (typeof options.description == 'undefined')
    options.description = defaultOptions.description;
  if (typeof options.popup == 'undefined')
    options.popup = defaultOptions.popup;
  if (typeof options.list == 'undefined')
    alert('No genes defined.');

  var form = document.createElement('form');
  form.setAttribute('method', 'post');
  form.setAttribute('action', 'https://amp.pharm.mssm.edu/Enrichr/enrich');
  if (options.popup)
    form.setAttribute('target', '_blank');
  form.setAttribute('enctype', 'multipart/form-data');

  var listField = document.createElement('input');
  listField.setAttribute('type', 'hidden');
  listField.setAttribute('name', 'list');
  listField.setAttribute('value', options.list);
  form.appendChild(listField);

  var descField = document.createElement('input');
  descField.setAttribute('type', 'hidden');
  descField.setAttribute('name', 'description');
  descField.setAttribute('value', options.description);
  form.appendChild(descField);

  document.body.appendChild(form);
  form.submit();
  document.body.removeChild(form);
}
    </script>
	
	{{if !empty($sankey_nodes)}} 
	 <script>
		    var sankey_data = {
            type: "sankey",
            orientation: "h",
            node: {
                pad: 10,
                thickness: 30,
                line: {
                    color: "black",
                    width: 2
                },
                label: {{$sankey_nodes}},
                color: 'RdBu'
            },

            link: {
                source: {{$sankey_src}},
                target: {{$sankey_target}},
                value:  {{$sankey_value}}
            }
        }

        var sankey_data = [sankey_data]

        var sankey_layout = {
			width:window.innerHeight-20,
            font: {
                size: 12
            },
	"titlefont": {
    "size": 16
	},
        }
        Plotly.react('sankey_div', sankey_data, sankey_layout)
		 </script>
		{{/if}}
	
	<div class="push"></div>
</main>
{{/block}}