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

$("#to_enrichr").click(function (){
                   get_gene_list(1,2);
            });
	  
	  	make_clust_main('data/{{$jobid}}/json/CT1.json','#container-id-1');
	  //flag.push("#container-id-1")
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

<main role="main" class="container">
    <div id="content">
 
        <div class="container">
            <br/>
            <div class="flatPanel panel panel-default">
                <div class="flatPanel panel-heading"><strong>Job ID: {{$jobid}}</strong></div>
                <div class="panel-body">

                    {{if $status == "1"}}
                    <div class="flatPanel panel panel-default">
                        <div class="panel-body">
                            <div class="col-md-12 col-sm-12">
                                <div class="form-group col-md-6 col-sm-6">
                                    <p for="reportsList">Species: {{$species}}</p>
                                </div>
                                <div class="form-group col-md-6 col-sm-6">
                                    <p>Number of Cells: {{$total_label}}</p>
                                </div>
                                <div class="form-group col-md-6 col-sm-6">
                                    <p>Number of Genes: {{$total_num}}</p>
                                </div>
                                <div class="form-group col-md-6 col-sm-6">
                                    <p>Number of Filtered Genes: {{$filter_num}}</p>
                                </div>
                                <div class="form-group col-md-6 col-sm-6">
                                    <p>Filtering Rate: {{$filter_rate*100}}%</p>
                                </div>
                                <div class="form-group col-md-6 col-sm-6">
                                    <p>Number of Cell Types: {{$total_ct}}</p>
                                </div>
                                <div class="form-group col-md-6 col-sm-6">
                                    <p>Total Biclusters: {{$total_bic}}</p>
                                </div>
                                <div class="form-group col-md-6 col-sm-6">
                                    <p>Number of Regulons: {{$total_regulon}}</p>
                                </div>

                            </div>
                        </div>
                    </div>
                    <div class="flatPanel panel panel-default">
                        <div class="panel-body">
                            <div class="row" style="">
                                <div class="form-group col-md-12 col-sm-12" style="height:100%">
                                    <strong>CTS Cell-Gene-Regulon Heatmap</strong>
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
																			<a href="/iris3/heatmap.php?jobid={{$jobid}}&file=CT{{$sec0+1}}.json" target="_blank">
                                                                        <button type="button" class="btn btn-submit" data-toggle="collapse" data-target="/iris3/heatmap.php?jobid={{$jobid}}&file=CT{{$sec0+1}}.json">Open in new tab
                                                                        </button>
                                                                    </a>
																				<div id="heatmap">
																						<div id='container-id-{{$sec0+1}}' style="height:95%;max-height:95%;max-width:100%;display:block">
																						<h1 class='wait_message'>Please wait ...</h1>
																					</div></div></div></div></div>
<div class="flatPanel panel panel-default">
																			<div class="row" >
																			<div class="form-group col-md-12 col-sm-12" style="height:100%">
																		<a href="/iris3/data/{{$jobid}}/{{$jobid}}_CT_{{$sec0+1}}_bic.regulon_gene_name.txt" target="_blank">
                                                                        <button type="button" class="btn btn-submit" data-toggle="collapse" data-target="/html/iris3/data/{{$jobid}}/{{$jobid}}_CT_{{$sec0+1}}_bic.regulon_gene_name.txt">Download CT-{{$sec0+1}}
                                                                        </button>
                                                                    </a>
																	<table id="motiftable" class="table table-bordered" cellpadding="0" cellspacing="0" width="100%">
                                                                    <thead>
                                                                        <tr>
                                                                        </tr>
                                                                    </thead>
                                                                    <tbody>
                                                                        {{section name=sec1 loop=$regulon_result[$sec0]}}
																		<tr ><td colspan=2 style="font-weight:600;text-align:center">{{$regulon_result[$sec0][sec1][0]}}</td></tr>
																		
                                                                        <tr >
                                                                            <td style="display:inline-block; overflow-y: scroll;width:49%;max-height:400px;">
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
																			<td style="witdh:49%;display:inline-block; overflow-y: auto;max-height:400px; border:none;" >
																			
                                                                                <div class="col-sm-12">
																				{{section name=sec3  start=1 loop=$regulon_motif_result[$sec0][sec1]}}
																				
																				{{assign var="this_motif" value=","|explode:$regulon_motif_result[$sec0][sec1][sec3]}}
																				
																					<span>{{$regulon_result[$sec0][sec1][0]}}-Motif-{{$smarty.section.sec3.index}}<a href="motif_detail.php?jobid={{$jobid}}&ct={{$this_motif[0]}}&bic={{$this_motif[1]}}&id={{$this_motif[2]}}" target="_blank"><img src="data/{{$jobid}}/logo/ct{{$this_motif[0]}}bic{{$this_motif[1]}}m{{$this_motif[2]}}.fsa.png" style="margin:auto;display:block"></a></span>
																					
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
                    <div class="row">
                        <div class="col-md-12">
                            <div class="panel with-nav-tabs panel-default">
                                <div class="panel-heading">
                                    <ul class="nav nav-tabs">
                                        <li class="active"><a href="#tab1default" data-toggle="tab">Cell Type Prediction</a></li>
                                        <li><a href="#tab2default" data-toggle="tab">CTS-Regulon</a></li>
                                        <li><a href="#tab3default" data-toggle="tab">Downloads</a></li>
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
                                                <tbody>
                                                    <tr>
                                                        <td><strong>Predicted Cell Type</strong></td>
														{{section name=ct_idx start=0 loop=$count_ct}}
															<td>{{$count_ct[ct_idx]}}</td>
                                                        {{/section}}
                                                    </tr>
													<tr>
													    <td><strong>Number of Predicted Cells</strong></td>
                                                        <!--<td>22</td>
														<td>8</td>
														<td>24</td>
														<td>14</td>
														<td>16</td>
														<td>6</td>-->
														{{section name=clust loop=$silh_trace}}<td>{{count($silh_x[{{$silh_trace[clust]}}])}}</td> {{/section}}
                                                    </tr>
                                                    <tr>
                                                        <td><strong>Number of Predicted Regulons</strong></td>
														{{section name=num_regulon_in_ct start=0 loop=$count_regulon_in_ct}}
															<td>{{$count_regulon_in_ct[num_regulon_in_ct]}}</td>
                                                        {{/section}}
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <!--<table id="tablePreview" class="table">
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
                                            </table>-->
                                            <div class="CT-result-img">
                                                <div class="col-sm-12">
                                                    <div id="score_div"></div>
												</div>
                                                <div class="col-sm-12">
                                                    <div id="sankey_div"></div>
												</div>
											</div>
										</div>
                                        <div class="tab-pane fade" id="tab2default">
                                            <div class="container">
                                                <div class="row">
                                                    <div class="col-md-11">
                                                        <ul class="nav nav-tabs" id="myTab" role="tablist">
                                                            <li class="nav-item active">
                                                                <a class="nav-link fade in active" id="home-tab" data-toggle="tab" href="#regulon-ct1" json="data/{{$jobid}}/CT1.json" root="#container-id-2" role="tab" aria-controls="home" aria-selected="true">CT1</a>
                                                            </li>
															{{section name=ct_idx start=1 loop=$count_ct}}
                                                            <li class="nav-item">
                                                                <a class="nav-link" id="profile-tab" data-toggle="tab" href="#regulon-ct{{$count_ct[ct_idx]}}" json="" root="#container-id-3" role="tab" aria-controls="profile" aria-selected="false">CT{{$count_ct[ct_idx]}}</a>
                                                            </li>
                                                            {{/section}}
                                                        </ul>
                                                        <div class="tab-content" id="myTabContent">
														 {{foreach from=$regulon_result item=label1 key=sec0}}
                                                            <div class="tab-pane {{if $sec0 eq '0'}}active{{/if}}" id="regulon-ct{{$sec0+1}}" role="tabpanel">
																

                                                            </div>
															
                                                           {{/foreach}}
                                                                    
                                                            </div>
                                                        </div>

                                                    </div>
                                                </div>
                                            </div>
                                        

                                        <div class="tab-pane fade" id="tab3default">
                                            <div class="container">
                                                <div class="row">
                                                    <div class="col-12 col-md-12">
                                                        <button type="button" class="btn btn-submit" data-toggle="collapse" data-target="#{{$annotation[sec1].Motifname}}_gene">Download All Files
                                                        </button>
                                                    </div>
                                                    <br>
                                                    <br>
                                                    <div class="col-12 col-md-12">
                                                        <button type="button" class="btn btn-submit" data-toggle="collapse" data-target="#{{$annotation[sec1].Motifname}}_gene">Filtered Expression Matrix
                                                        </button>
                                                        <button type="button" class="btn btn-submit" data-toggle="collapse" data-target="#{{$annotation[sec1].Motifname}}_gene">Bicluster Matrices
                                                        </button>
                                                        <button type="button" class="btn btn-submit" data-toggle="collapse" data-target="#{{$annotation[sec1].Motifname}}_gene">CTS-Biclusters
                                                        </button>
                                                        <button type="button" class="btn btn-submit" data-toggle="collapse" data-target="#{{$annotation[sec1].Motifname}}_gene">Cell type prediction
                                                        </button>
                                                        <button type="button" class="btn btn-submit" data-toggle="collapse" data-target="#{{$annotation[sec1].Motifname}}_gene">CTS-Regulon
                                                        </button>
                                                        <button type="button" class="btn btn-submit" data-toggle="collapse" data-target="#{{$annotation[sec1].Motifname}}_gene">Final Report
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
					{{elseif $status==="404"}}
					<div style="text-align: left;">
                        <p>Job ID nout found</p>
                    </div>
                    {{else}} {{block name="meta"}}
                    <META HTTP-EQUIV="REFRESH" CONTENT="15"> {{/block}}

                    <div style="text-align: left;">
                        <p>

                            <img src="static/images/busy.gif" />
                            <br /> Your request is received now.
                            <br> You can remember your jobid <font color="red"> <strong>{{$jobid}}</strong> </font>
                            <br> Or you can choose to stay at this page, which will be automatically refreshed every <b>15</b> seconds.
                            <br/> Link:&nbsp
                            <a href="{{$LINKPATH}}/iris3/results.php?jobid={{$jobid}}">http://bmbl.sdstate.edu/{{$LINKPATH}}iris3/results.php?jobid={{$jobid}}</a></p>

                    </div>
                    {{/if}}
                </div>
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
		title: "Sankey plot",
            font: {
                size: 16
            }
        }

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
		title: "Silhouette score",
            font: {
                size: 12
            }
        }
		Plotly.react('score_div', score_data, score_layout);
		
        Plotly.react('sankey_div', sankey_data, sankey_layout)
		
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
	<div class="push"></div>
</main>
{{/block}}