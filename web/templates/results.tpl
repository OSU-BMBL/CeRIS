{{extends file="base.tpl"}} {{block name="extra_js"}} {{/block}} {{block name="extra_style"}} {{/block}} {{block name="main"}}

<!-- Latest compiled and minified plotly.js JavaScript -->
<script src="https://cdn.plot.ly/plotly-latest.min.js"></script>

<!-- OR use a specific plotly.js release (e.g. version 1.5.0)
<script src="https://cdn.plot.ly/plotly-1.5.0.min.js"></script>
<script src="https://cdn.plot.ly/plotly-latest.js" charset="utf-8"></script> -->
<script>


var flag = [];
$(document).ready(function () {

document.getElementsByClassName("tomtom_pvalue").innerHTML = "test";
    $('#tablePreview').DataTable( {
  "searching": false,
  "paging": false,
  "bInfo" : false,
} );

	    
$("#to_enrichr").click(function (){
                   get_gene_list(1,2);
            });
	  
	  make_clust_main('data/{{$jobid}}/json/CT1.json','#container-id-1');
	  flag.push("#container-id-1")
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
//console.log(flag)
  var json_file = $(e.target).attr("json")
  var root_id = $(e.target).attr("root")
  //console.log(!arrayContains(root_id,flag))
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
                                    <p id="species">Species: {{$species}} {{$main_species}}{{if $second_species != ''}},{{/if}} {{$second_species}}</p>
                                </div>
                                <div class="form-group col-md-4 col-sm-4">
                                    <p>Number of cells: {{$total_label}}</p>
                                </div>
                                <div class="form-group col-md-4 col-sm-4">
                                    <p>Number of genes: {{$total_gene_num}}</p>
                                </div>
                                <div class="form-group col-md-4 col-sm-4">
                                    <p>Number of filtered genes: {{$filter_gene_num}}</p>
                                </div>
                                <div class="form-group col-md-4 col-sm-4">
                                    <p>Gene filtering ratio: {{$filter_gene_rate*100}}%</p>
                                </div>
								<div class="form-group col-md-4 col-sm-4">
                                    <p>Number of filtered cells: {{$filter_cell_num}}</p>
                                </div>
                                <div class="form-group col-md-4 col-sm-4">
                                    <p>Cell filtering ratio: {{$filter_cell_rate*100}}%</p>
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
                                    <p>Total CTS-Rs: {{$total_regulon}}</p>
                                </div>
<!--Table-->
                                            <table id="tablePreview" class="table">
                                                <!--Table head-->
                                                <thead>
                                                    <tr>
                                                        <th>{{if $label_use_sc3 == 'user\'s label'}}
														User's cell label index
														{{else}}
															Predicted cell label index
														{{/if}}</th>
                                                        {{if $label_use_sc3 == 'user\'s label'}}
															<th>
															User's cell label
															</th>
															{{/if}}
														<th>Number of cells</th>
                                                        <th>Number of CTS-Rs</th>
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
											<!--
											{{if ($saving_plot1  >0)}}
											<div class="col-ld-12">
											
											<hr>
											<h4 style="text-align:center"> SC3 consensus heatmap</h4> 
											<div class="dropdown"  id="drop_sc3">
											<button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true" style="border:1px solid #c9c9c9;border-radius:.25rem!important">Save image as: <span class="caret"></span>
											</button>
											<ul class="dropdown-menu" aria-labelledby="dropdownMenu1">
													<li><a class="dropdown-item" target="_blank" href="data/{{$jobid}}/saving_plot1.png" >png</a>
													</li>
													<li><a class="dropdown-item" target="_blank" href="data/{{$jobid}}/saving_plot1.jpeg" >jpeg</a>
													</li>
													<li><a class="dropdown-item" target="_blank" href="data/{{$jobid}}/saving_plot1.emf" >emf</a>
													</li>
													<li><a class="dropdown-item" target="_blank" href="data/{{$jobid}}/saving_plot1.pdf" >pdf</a>
													</li>
											</ul>
											</div>
											<img style="width:100%"src="data/{{$jobid}}/saving_plot1.jpeg"></img>
											</div>
											{{/if}}
											-->
											<div class="CT-result-img">
                                                <div class="col-sm-4">
												<h4 style="text-align:center;margin-top:50px"> PCA</h4>
                                                   <img style="width:100%"src="data/{{$jobid}}/pca.png"></img>
												</div>
												<div class="col-sm-4">
												<h4 style="text-align:center;margin-top:50px"> t-SNE</h4>
                                                   <img style="width:100%"src="data/{{$jobid}}/tsne.png"></img>
												</div>
												<div class="col-sm-4">
												<h4 style="text-align:center;margin-top:50px"> UMAP</h4>
                                                   <img style="width:100%"src="data/{{$jobid}}/umap.png"></img>
												</div>
											</div>
                                            <div class="CT-result-img">
                                                <div class="col-sm-12">
												<hr>
												<h4 style="text-align:center;margin-top:50px"> Silhouette score</h4>
													
                                                    <div id="score_div"></div>
												</div>
												
												{{if ($sankey_src|@count >0)}}
                                                <div class="col-sm-12">
												<hr>
												<h4 style="text-align:center;margin-top:50px"> Sankey plot</h4>
                                                    
													<div id="sankey_div"></div>
												</div>
												{{/if}}
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
                                    <p>Gene filtering: {{$is_gene_filter}}</p>
                                </div>
								<div class="form-group col-md-6 col-sm-6">
                                    <p>Cell filtering: {{$is_cell_filter}}</p>
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
                                    <p>Email: {{$email_line}}</p>
                                </div>
                                <div class="form-group col-md-6 col-sm-6">
                                    <p>Uploaded files: </p><p>{{$expfile_name}}</p><p>{{$labelfile_name}}</p><p>{{$gene_module_file_name}}</p>
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
															{{if $count_module > 0}}
															{{section name=ct_idx start=0 loop=$count_module}}
                                                            <li class="nav-item">
                                                                <a class="nav-link fade in " id="home-tab" data-toggle="tab" tabtype="main" href="#main_module{{$count_module[ct_idx]}}" json="data/{{$jobid}}/json/module{{$count_module[ct_idx]}}.json" root="#container-id-module-{{$count_module[ct_idx]}}" role="tab" aria-controls="home" aria-selected="true">module{{$count_module[ct_idx]}}</a>
                                                            </li>
															{{/section}}
															{{/if}}
															
															
															
                                                        </ul>
                                                        <div class="tab-content" id="myTabContent">	
														{{section name=ct_idx start=0 loop=$count_ct}}	{{/section}}
														{{foreach from=$regulon_result item=label1 key=sec0}}	
														{{if $regulon_result[$sec0][0][0] == '0'}}
																			<div class="tab-pane {{if {{$sec0+1}} eq '1'}}active{{/if}}" id="main_CT{{$sec0+1}}" role="tabpanel">
																<div class="flatPanel panel panel-default">
																			<div class="row" style="">
																			<div class="form-group col-md-12 col-sm-12" style="height:100%">
																			<strong>No CTS-R found in CT{{$sec0+1}} </strong>
																	</div></div> </div> </div> 
															{{else}}	
															<div class="tab-pane {{if {{$sec0+1}} eq '1'}}active{{/if}}" id="main_CT{{$sec0+1}}" role="tabpanel">
																<div class="flatPanel panel panel-default">
																			<div class="row" style="">
																			<div class="form-group col-md-12 col-sm-12" style="height:100%">
																			<strong>CTS Cell-Gene-Regulon Heatmap for Cell Type {{$sec0+1}}</strong><br>
																			
																			<a href="/iris3/heatmap.php?jobid={{$jobid}}&file=CT{{$sec0+1}}.json" target="_blank">
                                                                        <button type="button" class="btn btn-submit" data-toggle="collapse" data-target="/iris3/heatmap.php?jobid={{$jobid}}&file=CT{{$sec0+1}}.json">Open in new tab
                                                                        </button>
                                                                    </a>&nbsp;<a href="/iris3/data/{{$jobid}}/{{$jobid}}_CT_{{$sec0+1}}_bic.regulon_gene_name.txt" target="_blank">
                                                                        <button type="button" class="btn btn-submit" data-toggle="collapse" data-target="/html/iris3/data/{{$jobid}}/{{$jobid}}_CT_{{$sec0+1}}_bic.regulon_gene_name.txt">Download CT-{{$sec0+1}} regulon-gene list (Gene Symbol) 
                                                                        </button> </a>
																		<a href="/iris3/data/{{$jobid}}/{{$jobid}}_CT_{{$sec0+1}}_bic.regulon.txt" target="_blank">
																		<button type="button" class="btn btn-submit" data-toggle="collapse" data-target="/html/iris3/data/{{$jobid}}/{{$jobid}}_CT_{{$sec0+1}}_bic.regulon.txt">Download CT-{{$sec0+1}} regulon-gene list (Ensembl gene ID)
                                                                        </button>
                                                                    </a>
																	
																	<div class="panel-body"><div class="flatPanel panel panel-default">
																				<div id="heatmap">
																						<div id='container-id-{{$sec0+1}}' style="height:95%;max-height:95%;max-width:100%;display:block">
																						<h1 class='wait_message'>Please wait ...</h1>
																					</div></div></div></div></div></div>

																					</div> 
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
																		
                                                                        <tr>
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
																			<td style="display:inline-block; overflow-y: auto;max-height:400px; border:none;width:49%;">
                                                                                <div class="col-sm-12">
																				{{section name=sec3  start=1 loop=$regulon_motif_result[$sec0][sec1]}}
																				
																				{{assign var="this_motif" value=","|explode:$regulon_motif_result[$sec0][sec1][sec3]}}
																				
																					<span>{{$regulon_result[$sec0][sec1][0]}}-Motif-{{$smarty.section.sec3.index}}<a href="motif_detail.php?jobid={{$jobid}}&ct={{$this_motif[0]}}&bic={{$this_motif[1]}}&id={{$this_motif[2]}}" target="_blank"><img class="lozad" data-src="data/{{$jobid}}/logo/ct{{$this_motif[0]}}bic{{$this_motif[1]}}m{{$this_motif[2]}}.fsa.png" style="display:block;margin-left: auto;margin-right: auto;width: 50%;"/></a></span>
																					
									<input class="btn btn-submit" type="button" value="JASPAR" onClick="window.open('prepare_tomtom.php?jobid={{$jobid}}&ct={{$this_motif[0]}}&bic={{$this_motif[1]}}&m={{$this_motif[2]}}&db=JASPAR');"  />
									<input class="btn btn-submit" type="button" value="HOCOMOCO" onClick="window.open('prepare_tomtom.php?jobid={{$jobid}}&ct={{$this_motif[0]}}&bic={{$this_motif[1]}}&m={{$this_motif[2]}}&db=HOCOMOCO');"  />
									{{assign var=motif_num_jaspar value="ct`$this_motif[0]`bic`$this_motif[1]`m`$this_motif[2]`_JASPAR"}}
									{{assign var=motif_num_homo value="ct`$this_motif[0]`bic`$this_motif[1]`m`$this_motif[2]`_HOCOMOCO"}}
									<table id="tomtom_table" class="table table-bordered" cellpadding="0" cellspacing="0" width="100%">
									<thead>
                                        <tr>
										<td>
										Database
										</td>
										<td>
										Matched TF
										</td>
										<td>
										P-value
										</td>
										<td>
										E-value
										</td>
										<td>
										Q-value
										</td>
                                        </tr>
                                    </thead>
									<tbody>
									
									{{section name=tomtom_idx  start=0 loop=$tomtom_result.$motif_num_jaspar}}
									<tr>
									<td >
									JASPAR
									</td>
									<td>
									<a href="http://jaspar2018.genereg.net/matrix/{{$tomtom_result.$motif_num_jaspar[tomtom_idx][1]}}" target="_blank"> {{$tomtom_result.$motif_num_jaspar[tomtom_idx][1]}}</a>
									</td>
									<td class="tomtom_pvalue">
									{{$tomtom_result.$motif_num_jaspar[tomtom_idx][3]|string_format:"%.2e"}}
									</td>
									<td>
									{{$tomtom_result.$motif_num_jaspar[tomtom_idx][4]|string_format:"%.2e"}}
									</td>
									<td>
									{{$tomtom_result.$motif_num_jaspar[tomtom_idx][5]|string_format:"%.2e"}}
									</tr>
									{{/section}}
									{{section name=tomtom_idx  start=0 loop=$tomtom_result.$motif_num_homo}}
									<tr>
									<td >
									HOCOMOCO
									</td>
									<td>
									<a href="http://hocomoco11.autosome.ru/motif/{{$tomtom_result.$motif_num_homo[tomtom_idx][1]}}" target="_blank"> {{$tomtom_result.$motif_num_homo[tomtom_idx][1]}} </a>
									</td>
									<td>
									{{$tomtom_result.$motif_num_homo[tomtom_idx][3]|string_format:"%.2e"}}
									</td>
									<td>
									{{$tomtom_result.$motif_num_homo[tomtom_idx][4]|string_format:"%.2e"}}
									</td>
									<td>
									{{$tomtom_result.$motif_num_homo[tomtom_idx][5]|string_format:"%.2e"}}
									</tr>
									{{/section}}
									</tbody>
									</table>
									
									<hr>
                                                                                </div>
																				{{/section}}
                                                                            </td>
                                                                        </tr>
																		<tr><td><button type="button" class="btn btn-submit" data-toggle="collapse" id="{{$regulon_result[$sec0][sec1][0]}}" onclick="$('#heatmap-{{$regulon_result[$sec0][sec1][0]}}').show();make_clust('data/{{$jobid}}/json/{{$regulon_result[$sec0][sec1][0]}}.json','#ci-{{$regulon_result[$sec0][sec1][0]}}');flag.push('#ci-{{$regulon_result[$sec0][sec1][0]}}');$('#hide-{{$regulon_result[$sec0][sec1][0]}}').show();$('#{{$regulon_result[$sec0][sec1][0]}}').hide();">Heatmap
                                                        </button><button style="display:none;" type="button" class="btn btn-submit" data-toggle="collapse"  id="hide-{{$regulon_result[$sec0][sec1][0]}}" onclick="$('#ci-{{$regulon_result[$sec0][sec1][0]}}').removeAttr('style');$('#ci-{{$regulon_result[$sec0][sec1][0]}}').empty();$('#{{$regulon_result[$sec0][sec1][0]}}').show();$('#hide-{{$regulon_result[$sec0][sec1][0]}}').hide();">Hide Heatmap
                                                        </button>&nbsp;
														<button type="button" id="enrichr-{{$regulon_result[$sec0][sec1][0]}}" class="btn btn-submit" data-toggle="collapse" onclick="get_gene_list(this)" >Send gene list to Enrichr
                                                        </button>
														<button type="button" id="peakbtn-{{$regulon_result[$sec0][sec1][0]}}" class="btn btn-submit" data-toggle="collapse" onclick="show_peak_table(this);$('#peak_hidebtn-{{$regulon_result[$sec0][sec1][0]}}').show();$('#peak-{{$regulon_result[$sec0][sec1][0]}}').show();$('#peakbtn-{{$regulon_result[$sec0][sec1][0]}}').hide();" >ATAC-seq peak enrichment
                                                        </button>
														<button type="button" style="display:none;" id="peak_hidebtn-{{$regulon_result[$sec0][sec1][0]}}" class="btn btn-submit" data-toggle="collapse" onclick="$('#peakbtn-{{$regulon_result[$sec0][sec1][0]}}').show();$('#peak_hidebtn-{{$regulon_result[$sec0][sec1][0]}}').hide();$('#peak-{{$regulon_result[$sec0][sec1][0]}}').hide();" >Hide ATAC-seq peak enrichment
                                                        </button>
														<button type="button" id="tadbtn-{{$regulon_result[$sec0][sec1][0]}}" class="btn btn-submit" data-toggle="collapse" onclick="show_tad_table(this);$('#tad_hidebtn-{{$regulon_result[$sec0][sec1][0]}}').show();$('#tad-{{$regulon_result[$sec0][sec1][0]}}').show();$('#tadbtn-{{$regulon_result[$sec0][sec1][0]}}').hide();" >Additional TAD covered genes
                                                        </button>
														<button type="button" style="display:none;" id="tad_hidebtn-{{$regulon_result[$sec0][sec1][0]}}" class="btn btn-submit" data-toggle="collapse" onclick="$('#tadbtn-{{$regulon_result[$sec0][sec1][0]}}').show();$('#tad_hidebtn-{{$regulon_result[$sec0][sec1][0]}}').hide();$('#tad-{{$regulon_result[$sec0][sec1][0]}}').hide();" >Hide additional TAD covered genes
                                                        </button>
														<button type="button" id="similarbtn-{{$regulon_result[$sec0][sec1][0]}}" class="btn btn-submit" data-toggle="collapse" onclick="show_similar_table(this);$('#similar_hidebtn-{{$regulon_result[$sec0][sec1][0]}}').show();$('#similar-{{$regulon_result[$sec0][sec1][0]}}').show();$('#similarbtn-{{$regulon_result[$sec0][sec1][0]}}').hide();">Similar CTS-Rs
                                                        </button>
                                                        <button type="button" style="display:none;" id="similar_hidebtn-{{$regulon_result[$sec0][sec1][0]}}" class="btn btn-submit" data-toggle="collapse" onclick="$('#similarbtn-{{$regulon_result[$sec0][sec1][0]}}').show();$('#similar_hidebtn-{{$regulon_result[$sec0][sec1][0]}}').hide();$('#similar-{{$regulon_result[$sec0][sec1][0]}}').hide();">Hide similar CTS-Rs
                                                        </button>
														<button type="button" id="regulonbtn-{{$regulon_result[$sec0][sec1][0]}}" class="btn btn-submit" data-toggle="collapse" onclick="show_regulon_table(this);$('#regulon_hidebtn-{{$regulon_result[$sec0][sec1][0]}}').show();$('#regulon-{{$regulon_result[$sec0][sec1][0]}}').show();$('#regulonbtn-{{$regulon_result[$sec0][sec1][0]}}').hide();">Regulon t-SNE
                                                        </button>
                                                        <button type="button" style="display:none;" id="regulon_hidebtn-{{$regulon_result[$sec0][sec1][0]}}" class="btn btn-submit" data-toggle="collapse" onclick="$('#regulonbtn-{{$regulon_result[$sec0][sec1][0]}}').show();$('#regulon_hidebtn-{{$regulon_result[$sec0][sec1][0]}}').hide();$('#regulon-{{$regulon_result[$sec0][sec1][0]}}').hide();">Hide Regulon t-SNE
                                                        </button>
														</td></tr>
																		<tr>
																		<td colspan=2>
																		
																					<div id="heatmap-{{$regulon_result[$sec0][sec1][0]}}" style="display:none;">
																					<div class="panel-body"><div class="flatPanel panel panel-default">
																						<div id='ci-{{$regulon_result[$sec0][sec1][0]}}' style="max-width:100%;display:block">
																						<h1 class='wait_message'>Loading heatmap ...</h1>
																					</div>
																					</div></div> </div> 
																					<div id="peak-{{$regulon_result[$sec0][sec1][0]}}" style="display:none;">
																						<div id='table-{{$regulon_result[$sec0][sec1][0]}}' style="max-width:100%;display:block">
																					</div>
																					<table id="table-content-{{$regulon_result[$sec0][sec1][0]}}" class="display" style="font-size:12px;width:100%">
																						<thead>
																							<tr>
																								<th>Tissue/ Cell type</th>
																								<th># of ATAC-seq peaks</th>
																								<th># of included regulon genes</th>
																								<th>Rate in regulon</th>
																								<th>Species</th>
																								<th>CistromeDB ID</th>
																								<th>GEO accession</th>
																							</tr>
																						</thead>
																					</table>
																					</div>
																					<div id="tad-{{$regulon_result[$sec0][sec1][0]}}" style="display:none;">
																						<div id='tad-table-{{$regulon_result[$sec0][sec1][0]}}' style="max-width:100%;display:block">
																					</div>
																					<table id="tad-table-content-{{$regulon_result[$sec0][sec1][0]}}" class="display" style="font-size:12px;width:100%">
																						<thead>
																							<tr>
																								<th>Tissue/ Cell type</th>
																								<th>Species</th>
																								<th>Additional cell type specific genes found in TAD</th>
																							</tr>
																						</thead>
																					</table>
																					</div>
																					<div id="similar-{{$regulon_result[$sec0][sec1][0]}}" style="display:none;">
                                                                                    <div id='similar-table-{{$regulon_result[$sec0][sec1][0]}}' style="max-width:100%;display:block">
                                                                                    </div>
                                                                                    <table id="similar-table-content-{{$regulon_result[$sec0][sec1][0]}}" class="display" style="font-size:12px;width:100%">
                                                                                        <thead>
                                                                                            <tr>
                                                                                                <th>Similar CTS-Rs in other cell types</th>
                                                                                            </tr>
                                                                                        </thead>
                                                                                    </table>
																					</div>
																					<div id="regulon-{{$regulon_result[$sec0][sec1][0]}}" style="display:none;">
                                                                                    <div id='regulon-table-{{$regulon_result[$sec0][sec1][0]}}' style="max-width:100%;display:block">
                                                                                    </div>
                                                                                    <div id="regulon-table-content-{{$regulon_result[$sec0][sec1][0]}}" class="display" style="font-size:12px;width:100%">
                                                                                        
                                                                                    </div>
                                                                                </div>
																		</td>
																		</tr>

                                                                        {{/section}}
                                                                    </tbody>
                                                                </table>

																					
																	</div></div></div>
                                                            </div>	
															{{/if}}
															{{/foreach}}

															{{foreach from=$module_result item=label1 key=sec0}}														
															<div class="tab-pane " id="main_module{{$sec0+1}}" role="tabpanel">
																<div class="flatPanel panel panel-default">
																			<div class="row" style="">
																			<div class="form-group col-md-12 col-sm-12" style="height:100%">
																			<strong>Uploaded gene module heatmap {{$sec0+1}}</strong><br>
																			<a href="/iris3/heatmap.php?jobid={{$jobid}}&file=module{{$sec0+1}}.json" target="_blank">
                                                                        <button type="button" class="btn btn-submit" data-toggle="collapse" data-target="/iris3/heatmap.php?jobid={{$jobid}}&file=module{{$sec0+1}}.json">Open in new tab
                                                                        </button>
                                                                    </a>&nbsp;<a href="/iris3/data/{{$jobid}}/{{$jobid}}_module_{{$sec0+1}}_bic.regulon_gene_name.txt" target="_blank">
                                                                        <button type="button" class="btn btn-submit" data-toggle="collapse" data-target="/html/iris3/data/{{$jobid}}/{{$jobid}}_module_{{$sec0+1}}_bic.regulon_gene_name.txt">Download module-{{$sec0+1}} regulon-gene list (Gene symbol)
                                                                        </button></a>
																		<a href="/iris3/data/{{$jobid}}/{{$jobid}}_module_{{$sec0+1}}_bic.regulon.txt" target="_blank">
																		<button type="button" class="btn btn-submit" data-toggle="collapse" data-target="/html/iris3/data/{{$jobid}}/{{$jobid}}_module_{{$sec0+1}}_bic.regulon.txt">Download module-{{$sec0+1}} regulon-gene list (Ensembl gene ID) 
                                                                        </button>
                                                                    </a><div class="panel-body"><div class="flatPanel panel panel-default">
																				<div id="heatmap">
																						<div id='container-id-module-{{$sec0+1}}' style="height:95%;max-height:95%;max-width:100%;display:block">
																						<h1 class='wait_message'>Please wait ...</h1>
																					</div></div></div></div></div></div></div>
<div class="flatPanel panel panel-default">
																			<div class="row" >
																			<div class="form-group col-md-12 col-sm-12" style="height:100%">
																		
																	<table id="motiftable" class="table table-bordered" cellpadding="0" cellspacing="0" width="100%">
                                                                    <thead>
                                                                        <tr>
                                                                        </tr>
                                                                    </thead>
                                                                    <tbody>
                                                                        {{section name=sec1 loop=$module_result[$sec0]}}
																		<tr ><td colspan=2 style="font-weight:600;text-align:center">{{$module_result[$sec0][sec1][0]}}</td></tr>
																		
                                                                        <tr >
                                                                            <td style="display:inline-block; overflow-y: auto;width:49%;max-height:400px;">
                                                                                <div style="width:100%; font-size:14px;">
																				<table class="table table-bordered table-hover" >
	                                 
	                                
                                  {{section name=sec2 start=1 loop=$module_result[$sec0][sec1]}}
                                          <tr >
                                         <td><a  target="_blank" href= "https://www.genecards.org/cgi-bin/carddisp.pl?gene={{$module_result[$sec0][sec1][sec2]}}" style="font-size:14px; display: inline-block;">{{$module_result[$sec0][sec1][sec2]}}&nbsp;</a></td>
										 									
                                         <td><a  target="_blank" href= "https://www.ensembl.org/id/{{$module_id_result[$sec0][sec1][sec2]}}" style="font-size:14px; display: inline-block;">{{$module_id_result[$sec0][sec1][sec2]}}&nbsp;</a></td>
										 
										 {{/section}}
                                         </tr>
                                   
                                 </table>
											</div>										
																				

                                                                            </td>
																			<td style="display:inline-block; overflow-y: auto;max-height:400px; border:none;width:49%;">
                                                                                <div class="col-sm-12">
																				{{section name=sec3  start=1 loop=$module_motif_result[$sec0][sec1]}}
																				
																				{{assign var="this_motif" value=","|explode:$module_motif_result[$sec0][sec1][sec3]}}
																				
																					<span>{{$module_result[$sec0][sec1][0]}}-Motif-{{$smarty.section.sec3.index}}<a href="motif_detail.php?jobid={{$jobid}}&module={{$this_motif[0]}}&bic={{$this_motif[1]}}&id={{$this_motif[2]}}" target="_blank"><img class="lozad" data-src="data/{{$jobid}}/logo/module{{$this_motif[0]}}bic{{$this_motif[1]}}m{{$this_motif[2]}}.fsa.png" style="display:block;margin-left: auto;margin-right: auto;width: 50%;"/></a></span>
																					
									<input class="btn btn-submit" type="button" value="JASPAR" onClick="window.open('prepare_tomtom.php?jobid={{$jobid}}&module={{$this_motif[0]}}&bic={{$this_motif[1]}}&m={{$this_motif[2]}}&db=JASPAR');"  />
									<input class="btn btn-submit" type="button" value="HOCOMOCO" onClick="window.open('prepare_tomtom.php?jobid={{$jobid}}&module={{$this_motif[0]}}&bic={{$this_motif[1]}}&m={{$this_motif[2]}}&db=HOCOMOCO');"  />
									
									{{assign var=motif_num_jaspar value="module`$this_motif[0]`bic`$this_motif[1]`m`$this_motif[2]`_JASPAR"}}
									{{assign var=motif_num_homo value="module`$this_motif[0]`bic`$this_motif[1]`m`$this_motif[2]`_HOCOMOCO"}}
									<table id="tomtom_module_table" class="table table-bordered" cellpadding="0" cellspacing="0" width="100%">
									<thead>
                                        <tr>
										<td>
										Database
										</td>
										<td>
										Matched TF
										</td>
										<td>
										P-value
										</td>
										<td>
										E-value
										</td>
										<td>
										Q-value
										</td>
                                        </tr>
                                    </thead>
									<tbody>
									
									{{section name=tomtom_idx  start=0 loop=$tomtom_result.$motif_num_jaspar}}
									<tr>
									<td>
									JASPAR
									</td>
									<td>
									<a href="http://jaspar2018.genereg.net/matrix/{{$tomtom_result.$motif_num_jaspar[tomtom_idx][1]}}" target="_blank"> {{$tomtom_result.$motif_num_jaspar[tomtom_idx][1]}}</a>
									</td>
									<td class="tomtom_pvalue">
									{{$tomtom_result.$motif_num_jaspar[tomtom_idx][3]|string_format:"%.2e"}}
									</td>
									<td>
									{{$tomtom_result.$motif_num_jaspar[tomtom_idx][4]|string_format:"%.2e"}}
									</td>
									<td>
									{{$tomtom_result.$motif_num_jaspar[tomtom_idx][5]|string_format:"%.2e"}}
									</tr>
									{{/section}}
									{{section name=tomtom_idx  start=0 loop=$tomtom_result.$motif_num_homo}}
									<tr>
									<td>
									HOCOMOCO
									</td>
									<td>
									<a href="http://hocomoco11.autosome.ru/motif/{{$tomtom_result.$motif_num_homo[tomtom_idx][1]}}" target="_blank"> {{$tomtom_result.$motif_num_homo[tomtom_idx][1]}} </a>
									</td>
									<td>
									{{$tomtom_result.$motif_num_homo[tomtom_idx][3]|string_format:"%.2e"}}
									</td>
									<td>
									{{$tomtom_result.$motif_num_homo[tomtom_idx][4]|string_format:"%.2e"}}
									</td>
									<td>
									{{$tomtom_result.$motif_num_homo[tomtom_idx][5]|string_format:"%.2e"}}
									</tr>
									{{/section}}
									</tbody>
									</table>
									
									<hr>
                                                                                </div>
																				{{/section}}
                                                                            </td>
                                                                        </tr>
																		<tr><td><button type="button" class="btn btn-submit" data-toggle="collapse" id="{{$module_result[$sec0][sec1][0]}}" onclick="console.log('{{$module_result[$sec0][sec1][0]}}');$('#heatmap-{{$module_result[$sec0][sec1][0]}}').show();make_clust('data/{{$jobid}}/json/{{$module_result[$sec0][sec1][0]}}.json','#ci-{{$module_result[$sec0][sec1][0]}}');flag.push('#ci-{{$module_result[$sec0][sec1][0]}}');$('#hide-{{$module_result[$sec0][sec1][0]}}').show();$('#{{$module_result[$sec0][sec1][0]}}').hide();">Show Heatmap
                                                        </button><button style="display:none;" type="button" class="btn btn-submit" data-toggle="collapse"  id="hide-{{$module_result[$sec0][sec1][0]}}" onclick="$('#ci-{{$module_result[$sec0][sec1][0]}}').removeAttr('style');$('#ci-{{$module_result[$sec0][sec1][0]}}').empty();$('#{{$module_result[$sec0][sec1][0]}}').show();$('#hide-{{$module_result[$sec0][sec1][0]}}').hide();">Hide Heatmap
                                                        </button>&nbsp;<button type="button" id="enrichr-{{$module_result[$sec0][sec1][0]}}" class="btn btn-submit" data-toggle="collapse" onclick="get_gene_list(this)" >Send gene list to Enrichr
                                                        </button>
														<button type="button" id="peakbtn-{{$module_result[$sec0][sec1][0]}}" class="btn btn-submit" data-toggle="collapse" onclick="show_peak_table(this);$('#peak_hidebtn-{{$module_result[$sec0][sec1][0]}}').show();$('#peak-{{$module_result[$sec0][sec1][0]}}').show();$('#peakbtn-{{$module_result[$sec0][sec1][0]}}').hide();" >Show ATAC-seq peak enrichment
                                                        </button>
														<button type="button" style="display:none;" id="peak_hidebtn-{{$module_result[$sec0][sec1][0]}}" class="btn btn-submit" data-toggle="collapse" onclick="$('#peakbtn-{{$module_result[$sec0][sec1][0]}}').show();$('#peak_hidebtn-{{$module_result[$sec0][sec1][0]}}').hide();$('#peak-{{$module_result[$sec0][sec1][0]}}').hide();" >Hide ATAC-seq peak enrichment
                                                        </button>
														<button type="button" id="tadbtn-{{$module_result[$sec0][sec1][0]}}" class="btn btn-submit" data-toggle="collapse" onclick="show_tad_table(this);$('#tad_hidebtn-{{$module_result[$sec0][sec1][0]}}').show();$('#tad-{{$module_result[$sec0][sec1][0]}}').show();$('#tadbtn-{{$module_result[$sec0][sec1][0]}}').hide();" >Show additional TAD covered genes
                                                        </button>
														<button type="button" style="display:none;" id="tad_hidebtn-{{$module_result[$sec0][sec1][0]}}" class="btn btn-submit" data-toggle="collapse" onclick="$('#tadbtn-{{$module_result[$sec0][sec1][0]}}').show();$('#tad_hidebtn-{{$module_result[$sec0][sec1][0]}}').hide();$('#tad-{{$module_result[$sec0][sec1][0]}}').hide();" >Hide additional TAD covered genes
                                                        </button>
														</td></tr>
																		<tr >
																		<td colspan=2>
																		
																					<div id="heatmap-{{$module_result[$sec0][sec1][0]}}" style="display:none;">
																					<div class="panel-body"><div class="flatPanel panel panel-default">
																						<div id='ci-{{$module_result[$sec0][sec1][0]}}' style="max-width:100%;display:block">
																						<h1 class='wait_message'>Loading heatmap ...</h1>
																					</div></div></div> </div> 
																					<div id="peak-{{$module_result[$sec0][sec1][0]}}" style="display:none;">
																						<div id='table-{{$module_result[$sec0][sec1][0]}}' style="max-width:100%;display:block">
																					</div>
																					<table id="table-content-{{$module_result[$sec0][sec1][0]}}" class="display" style="width:100%">
																						<thead>
																							<tr>
																								<th>Tissue/ Cell type</th>
																								<th># of ATAC-seq peaks</th>
																								<th># of included regulon genes</th>
																								<th>Rate in regulon</th>
																								<th>Species</th>
																								<th>CistromeDB ID</th>
																								<th>GEO accession</th>
																							</tr>
																						</thead>
																					</table>
																					</div>
																					<div id="tad-{{$module_result[$sec0][sec1][0]}}" style="display:none;">
																						<div id='tad-table-{{$module_result[$sec0][sec1][0]}}' style="max-width:100%;display:block">
																					</div>
																					<table id="tad-table-content-{{$module_result[$sec0][sec1][0]}}" class="display" style="font-size:12px;width:100%">
																						<thead>
																							<tr>
																								<th>Tissue/ Cell type</th>
																								<th>Species</th>
																								<th>Additional cell type specific genes found in TAD</th>
																							</tr>
																						</thead>
																					</table>
																					</div>
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
						<p>Note that currently we accept human and mouse expression matrix for submission, Each gene measured in the expression dataset should have an identifier listed in the first column, both Gene Symbols (e.g. HSPA9) and Gene IDs (e.g. ENSG00000113013) are allowed. Pleas check our <a href="https://bmbl.bmi.osumc.edu/iris3/tutorial.php#1basics">tutorial</a> for more information. </p>
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
                                    <p>Gene filtering: {{$is_gene_filter}}</p>
                                </div>
								<div class="form-group col-md-6 col-sm-6">
                                    <p>Cell filtering: {{$is_cell_filter}}</p>
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
                                    <p>Email: {{$email_line}}</p>
                                </div>
                                <div class="form-group col-md-6 col-sm-6"> 
                                    <p>Uploaded files: </p><p>{{$expfile_name}}</p><p>{{$labelfile_name}}</p><p>{{$gene_module_file_name}}</p>
                                </div>
								
                                
                                

                            </div>
					</div>
					{{elseif $status==="error_bic"}}
					<div class="flatPanel panel-heading" style="padding: 20px 20px"><strong>Job ID: {{$jobid}}</strong></div>
						<div class="panel-body">
					<div style="text-align: left;">
                        <strong><h3>Sorry, there has been an error:</h3></strong> <p style="color:red">IRIS3 did not find enough bi-clusters in your data.</p>
						<p>Note that currently we accept human and mouse expression matrix for submission, Each gene measured in the expression dataset should have an identifier listed in the first column, both Gene Symbols (e.g. HSPA9) and Gene IDs (e.g. ENSG00000113013) are allowed. Pleas check our <a href="https://bmbl.bmi.osumc.edu/iris3/tutorial.php#1basics">tutorial</a> for more information. </p>
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
                                    <p>Gene filtering: {{$is_gene_filter}}</p>
                                </div>
								<div class="form-group col-md-6 col-sm-6">
                                    <p>Cell filtering: {{$is_cell_filter}}</p>
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
                                    <p>Email: {{$email_line}}</p>
                                </div>
                                <div class="form-group col-md-6 col-sm-6"> 
                                    <p>Uploaded files: </p><p>{{$expfile_name}}</p><p>{{$labelfile_name}}</p><p>{{$gene_module_file_name}}</p>
                                </div>
								
                                
                                

                            </div>
					</div>
										{{elseif $status==="error_num_cells"}}
					<div class="flatPanel panel-heading" style="padding: 20px 20px"><strong>Job ID: {{$jobid}}</strong></div>
						<div class="panel-body">
					<div style="text-align: left;">
                        <strong><h3>Sorry, there has been an error</h3></strong> <p style="color:red">Please check with your data format (input file should be txt, csv or tsv format): <br>1. Gene expression matrix: Gene expression matrix (GEMAT) file with genes as rows and cells as columns. <br>2. Cell label file (Optional): a two-column matrix with the first column as the cell names exactly matching the gene expression file, and the second column as ground-truth cell clusters. <br>3. Gene module file (Optional): Each column should reprensents a gene module.</p>
						<br>For further question, please contact ma.1915@osu.edu<br>
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
                                    <p>Gene filtering: {{$is_gene_filter}}</p>
                                </div>
								<div class="form-group col-md-6 col-sm-6">
                                    <p>Cell filtering: {{$is_cell_filter}}</p>
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
                                    <p>Email: {{$email_line}}</p>
                                </div>
                                <div class="form-group col-md-6 col-sm-6"> 
                                    <p>Uploaded files: </p><p>{{$expfile_name}}</p><p>{{$labelfile_name}}</p><p>{{$gene_module_file_name}}</p>
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
                            <br> Or you can choose to stay at this page, which will be automatically refreshed every <b>30</b> seconds.
                            <br/> Link:&nbsp
                            <a href="{{$LINKPATH}}/iris3/results.php?jobid={{$jobid}}">https://bmbl.bmi.osumc.edu/{{$LINKPATH}}iris3/results.php?jobid={{$jobid}}</a></p>
							
							
							<strong>Job settings:</strong><br>
                            <div class="col-md-12 col-sm-12">
                                <div class="form-group col-md-6 col-sm-6">
                                    <p for="reportsList">Allow data storage in our database: {{$if_allowSave}}</p>
                                </div>
                                <div class="form-group col-md-6 col-sm-6">
                                    <p>Gene filtering: {{$is_gene_filter}}</p>
                                </div>
								<div class="form-group col-md-6 col-sm-6">
                                    <p>Cell filtering: {{$is_cell_filter}}</p>
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
                                    <p>Email: {{$email_line}}</p>
                                </div>
                                <div class="form-group col-md-6 col-sm-6"> 
                                    <p>Uploaded files: </p><p>{{$expfile_name}}</p><p>{{$labelfile_name}}</p><p>{{$gene_module_file_name}}</p>
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
const observer = lozad(); // lazy loads elements with default selector as '.lozad'
observer.observe();
color_array3=["#FFFF00", "#1CE6FF", "#FF34FF", "#FFE119", "#008941", "#006FA6", "#A30059",
"#7A4900", "#0000A6", "#63FFAC", "#B79762", "#004D43", "#8FB0FF", "#997D87",
"#5A0007", "#809693", "#FEFFE6", "#1B4400", "#4FC601", "#3B5DFF", "#4A3B53", "#FF2F80",
"#61615A", "#BA0900", "#6B7900", "#00C2A0", "#FFAA92", "#FF90C9", "#B903AA", "#D16100",
"#DDEFFF", "#000035", "#7B4F4B", "#A1C299", "#300018", "#0AA6D8", "#013349", "#00846F",
"#372101", "#FFB500", "#C2FFED", "#A079BF", "#CC0744", "#C0B9B2", "#C2FF99", "#001E09",
"#00489C", "#6F0062", "#0CBD66", "#EEC3FF", "#456D75", "#B77B68", "#7A87A1", "#788D66",
"#885578", "#0089A3", "#FF8A9A", "#D157A0", "#BEC459", "#456648", "#0086ED", "#886F4C",
"#34362D", "#B4A8BD", "#00A6AA", "#452C2C", "#636375", "#A3C8C9", "#FF913F", "#938A81",
"#575329", "#00FECF", "#B05B6F", "#8CD0FF", "#3B9700", "#04F757", "#C8A1A1", "#1E6E00",
"#7900D7", "#A77500", "#6367A9", "#A05837", "#6B002C", "#772600", "#D790FF", "#9B9700",
"#549E79", "#FFF69F", "#201625", "#CB7E98", "#72418F", "#BC23FF", "#99ADC0", "#3A2465", "#922329",
"#5B4534", "#FDE8DC", "#404E55", "#FAD09F", "#A4E804", "#f58231", "#324E72", "#402334"];
{{section name=clust loop=$silh_trace}}
var trace{{$silh_trace[clust]}} = {
  x: [{{section name=idx loop=$silh_x[{{$silh_trace[clust]}}]}} "{{$silh_x[{{$silh_trace[clust]}}][idx]}}",{{/section}}],
  y: [{{section name=idx loop=$silh_y[{{$silh_trace[clust]}}]}} "{{$silh_y[{{$silh_trace[clust]}}][idx]}}",{{/section}}],
  name: '{{$silh_trace[clust]}}',
  marker:{
    color: [{{section name=idx loop=$silh_y[{{$silh_trace[clust]}}]}} color_array3[{{$silh_trace[clust]}}],{{/section}}]
  },
  type: 'bar'
};

{{/section}}


var score_data = [{{section name=clust loop=$silh_trace}}trace{{$silh_trace[clust]}},  {{/section}}];

		var score_layout = {
		title: "",
		autosize:true,
		barmode: 'group',
			width:window.innerHeight-10,
            font: {
                size: 12
            },
	"titlefont": {
    "size": 16
	},
	"xaxis": {
	visible:false,
	tickangle: -45,
	},
        }
		var score_config = {
  toImageButtonOptions: {
	title: 'Download plot as a svg',
    format: 'svg', // one of png, svg, jpeg, webp
    filename: 'new_image',
    height: 1000,
    width: 1400,
    scale: 1 // Multiply title/legend/axis/canvas sizes by this factor
  },
  showLink: true,
  displayModeBar: true,
  modeBarButtonsToRemove:['zoom2d', 'pan2d', 'select2d', 'lasso2d', 'zoomIn2d', 'zoomOut2d', 'autoScale2d','hoverClosestCartesian', 'hoverCompareCartesian','hoverClosest3d','toggleHover','hoverClosestGl2d','hoverClosestPie','toggleSpikelines']
};
		Plotly.react('score_div', score_data, score_layout, score_config);
		
	
	function show_peak_table(item){
		match_id = $(item).attr("id").match(/\d+/gm)
		regulon_id = $(item).attr("id").substring(8);
		table_id = "table-"+regulon_id
		species = document.getElementById("species").innerHTML
		match_species =  species.match(/[^Species: ].+/gm)[0]
		jobid = location.search.match(/\d+/gm)
		table_content_id = "table-content-"+regulon_id
		table_jquery_id="#"+table_content_id
		if ( ! $.fn.DataTable.isDataTable(table_jquery_id) ) {
		$(table_jquery_id).DataTable( {
				dom: 'lBfrtip',
				buttons: [
				{
				extend:'copy',
				title: jobid+'_'+regulon_id+'_peak'
				},
				{
				extend:'csv',
				title: jobid+'_'+regulon_id+'_peak'
				}
				],
				"ajax": "prepare_peak.php?jobid="+jobid+"&regulon_id="+regulon_id+"&species="+match_species+"&table="+table_content_id,
				"searching": false,
				"bInfo" : false,
				"order": [[ 3, "desc" ]],
				columnDefs: [
				{
					targets: 6,
					render: function (data, type, row, meta)
					{
						if (type === 'display')
						{
							data = '<a  href="http://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=' +data+ '" target="_blank">'+data +'</a>';
						}
						return data;
					}
				}],
		
		});
		}
		document.getElementById(table_id).innerHTML=""
	}
	
	
	function show_tad_table(item){
		match_id = $(item).attr("id").match(/\d+/gm)
		regulon_id = $(item).attr("id").substring(7);
		table_id = "tad-table-"+regulon_id
		species = document.getElementById("species").innerHTML
		match_species =  species.match(/[^Species: ].+/gm)[0]
		jobid = location.search.match(/\d+/gm)
		table_content_id = "tad-table-content-"+regulon_id
		table_jquery_id="#"+table_content_id
		if ( ! $.fn.DataTable.isDataTable(table_jquery_id) ){
			if(match_species=='Human'){
			$(table_jquery_id).DataTable( {
				dom: 'lBfrtip',
				buttons: [
				{
				extend:'copy',
				title: jobid+'_'+regulon_id+'_TAD_covered_genes'
				},
				{
				extend:'csv',
				title: jobid+'_'+regulon_id+'_TAD_covered_genes'
				}
				],
				"ajax": "prepare_tad.php?jobid="+jobid+"&regulon_id="+regulon_id+"&species="+match_species+"&table="+table_content_id,
				"searching": false,
				"bInfo" : false,
				"aLengthMenu": [[5, 10, -1], [5, 10, "All"]],
			"iDisplayLength": 5,
		});
			} else if (match_species == 'Mouse'){
			$(table_jquery_id).DataTable( {
				dom: 'lBfrtip',
				buttons: [
				{
				extend:'copy',
				title: jobid+'_'+regulon_id+'_TAD_covered_genes'
				},
				{
				extend:'csv',
				title: jobid+'_'+regulon_id+'_TAD_covered_genes'
				}
				],
				"ajax": "prepare_tad.php?jobid="+jobid+"&regulon_id="+regulon_id+"&species="+match_species+"&table="+table_content_id,
				"searching": false,
				"bInfo" : false,
				"aLengthMenu": [[ -1], [ "All"]],
				"iDisplayLength": -1,
		});
			}
		}
		document.getElementById(table_id).innerHTML=""
	}
	function show_similar_table(item) {
	match_id = $(item).attr("id").match(/\d+/gm)
	regulon_id = $(item).attr("id").substring(11)
	table_id = "similar-table-" + regulon_id
	species = document.getElementById("species").innerHTML
	match_species = species.match(/[^Species: ].+/gm)[0]
	jobid = location.search.match(/\d+/gm)
	table_content_id = "similar-table-content-" + regulon_id
	table_jquery_id = "#" + table_content_id
	if (!$.fn.DataTable.isDataTable(table_jquery_id)) {
	$(table_jquery_id).DataTable({
		dom: 'lBfrtip',
		buttons: [
				{
				extend:'copy',
				title: jobid+'_'+regulon_id+'_similar_regulon'
				},
				{
				extend:'csv',
				title: jobid+'_'+regulon_id+'_similar_regulon'
				}
				],
		"ajax": "prepare_similar_regulon.php?jobid=" + jobid + "&regulon_id=" + regulon_id + "&species=" + match_species + "&table=" + table_content_id,
		"searching": false,
		"paging": false,
		"bInfo" : false,
		"aLengthMenu": [
			[10, -1],
			[10, "All"]
		],
		"iDisplayLength": 10,
		
	});
	}
	document.getElementById(table_id).innerHTML = ""
	}
	
	function show_regulon_table(item) {
	match_id = $(item).attr("id").match(/\d+/gm)
	regulon_id = $(item).attr("id").substring(11)
	table_id = "regulon-table-" + regulon_id
	species = document.getElementById("species").innerHTML
	match_species = species.match(/[^Species: ].+/gm)[0]
	jobid = location.search.match(/\d+/gm)
	table_content_id = "regulon-table-content-" + regulon_id
	table_jquery_id = "#" + table_content_id
	$.ajax({
		url: "prepare_regulon_tsne.php?jobid=" + jobid + "&id=" + regulon_id,
		type: 'POST',
		data: {'id': regulon_id},
		dataType: 'json',
		success: function(response) {
		document.getElementById(table_id).innerHTML = '<div class="col-sm-6"><p>t-SNE plot in this CT</p><img src="./data/'+jobid+'/regulon_id/overview_' + regulon_id + '.png" /></div><div class="col-sm-6"><p>Regulon '+ regulon_id +' t-SNE plot</p><img src="./data/'+jobid+'/regulon_id/' + regulon_id + '.png" /></div>'
		},
	})
	document.getElementById(table_id).innerHTML = ""
	}
	
	function get_gene_list(item){
	match_id = $(item).attr("id").match(/\d+/gm);
	if($(item).attr("id").includes("CT")) {
		file_path = 'data/'+ {{$jobid}} +'/'+{{$jobid}} + '_CT_'+match_id[0]+'_bic.regulon_gene_name.txt';
	} else {
		file_path = 'data/'+ {{$jobid}} +'/'+{{$jobid}} + '_module_'+match_id[0]+'_bic.regulon_gene_name.txt';
	}
	
	
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
                //color: 'RdBu'
				color:[{{section name=clust loop=$silh_trace}} color_array3[{{$silh_trace[clust]}}],{{/section}}{{for $clust= 0 to $sankey_nodes_count-1}} color_array3[64-{{$sankey_label_order[$clust]}}],{{/for}}]
            },
            link: {
                source: {{$sankey_src}},
                target: {{$sankey_target}},
                value:  {{$sankey_value}}
            }
        }
        var sankey_data = [sankey_data]
        var sankey_layout = {
		title: "",
		autosize:true,
		responsive: true,
		width:window.innerHeight-10,
            font: {
                size: 12
            },
		"titlefont": {
		"size": 16
		},
        }
        Plotly.react('sankey_div', sankey_data, sankey_layout,score_config)
		 </script>
		{{/if}}
	<div class="push"></div>
</main>
{{/block}}