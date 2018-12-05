{{extends file="base.tpl"}} {{block name="extra_js"}} {{/block}} {{block name="extra_style"}} {{/block}} {{block name="main"}}

<!-- Latest compiled and minified plotly.js JavaScript -->
<script src="https://cdn.plot.ly/plotly-latest.min.js"></script>

<!-- OR use a specific plotly.js release (e.g. version 1.5.0) -->
<script src="https://cdn.plot.ly/plotly-1.5.0.min.js"></script>

<!-- OR an un-minified version is also available -->
<script src="https://cdn.plot.ly/plotly-latest.js" charset="utf-8"></script>
<script>
$(document).ready(function () {

	  var flag = [];
	  	
	  flag.push("#container-id-11")
	  function arrayContains(needle, arrhaystack)
		{
    return (arrhaystack.indexOf(needle) > -1);
		}
		
$('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
console.log(flag)
  var json_file = $(e.target).attr("json")
  var root_id = $(e.target).attr("root")
  console.log(!arrayContains(root_id,flag))
	if (!arrayContains(root_id,flag)){

	make_clust(json_file,root_id);

	flag.push(root_id)
	//var element_group = document.getElementsByClassName('row_slider_group');
	//for (i in element_group)
	//	i.style.display='none';
	}
    });
	//flag.push("#container-id-11")


});
</script>

<main role="main" class="container">
    <div id="content">

        <div class="container">
            <br/>
            <div class="flatPanel panel panel-default">
                <div class="flatPanel panel-heading"><strong>Job ID: 20181124190953</strong></div>
                <div class="panel-body">

                    {{if $status == "1"}}
                    <div class="flatPanel panel panel-default">
                        <div class="panel-body">
                            <div class="col-md-12 col-sm-12">
                                <div class="form-group col-md-6 col-sm-6">
                                    <p for="reportsList">Species: Human</p>
                                </div>
                                <div class="form-group col-md-6 col-sm-6">
                                    <p>Number of Cells: 90</p>
                                </div>
                                <div class="form-group col-md-6 col-sm-6">
                                    <p>Number of Genes: 20414</p>
                                </div>
                                <div class="form-group col-md-6 col-sm-6">
                                    <p>Number of Filtered Genes: 6783</p>
                                </div>
                                <div class="form-group col-md-6 col-sm-6">
                                    <p>Filtering Rate: 34%</p>
                                </div>
                                <div class="form-group col-md-6 col-sm-6">
                                    <p>Number of Predicted Cell Types: 6</p>
                                </div>
                                <div class="form-group col-md-6 col-sm-6">
                                    <p>Cell p: Yes</p>
                                </div>
                                <div class="form-group col-md-6 col-sm-6">
                                    <p>Total Biclusters: 42</p>
                                </div>
                                <div class="form-group col-md-6 col-sm-6">
                                    <p>Number of Regulons: 33</p>
                                </div>

                            </div>
                        </div>
                    </div>
                    <div class="flatPanel panel panel-default">
                        <div class="panel-body">
                            <div class="row" style="">
                                <div class="form-group col-md-12 col-sm-12" style="height:100%">
                                    <h3>CTS Cell-Gene-Regulon Heatmap</h3>
									     <ul class="nav nav-tabs" id="myTab" role="tablist">
                                                            <li class="nav-item active">
                                                                <a class="nav-link fade in active" id="home-tab" data-toggle="tab" href="#main_CT1" json="data/{{$jobid}}/11.json" root="#container-id-11" role="tab" aria-controls="home" aria-selected="true">Cell Type1</a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a class="nav-link" id="profile-tab" data-toggle="tab" href="#main_CT2" json="data/{{$jobid}}/12.json" root="#container-id-12" role="tab" aria-controls="profile" aria-selected="false">Cell Type2</a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a class="nav-link" id="contact-tab" data-toggle="tab" href="#main_CT3" json="13.json" root="#container-id-13" role="tab" aria-controls="contact" aria-selected="false">Cell Type3</a>
                                                            </li>
                                                        </ul>
                                                        <div class="tab-content" id="myTabContent">
														<div class="tab-pane active" id="main_CT1" role="tabpanel">
																<div class="flatPanel panel panel-default">
																			<div class="row" style="">
																			<div class="form-group col-md-12 col-sm-12" style="height:100%">
																			<a href="/iris3/heatmap.php?jobid={{$jobid}}&file=11.json" target="_blank">
                                                                        <button type="button" class="btn btn-success" data-toggle="collapse" data-target="/iris3/heatmap.php?jobid={{$jobid}}&file=11.json">Open in new tab
                                                                        </button>
                                                                    </a>
																				<div id="heatmap">
																						<div id='container-id-11' style="height:95%;max-height:95%;max-width:100%;display:block">
																						<h1 class='wait_message'>Please wait ...</h1>
																					</div></div></div></div></div>

                                                            </div>	
															<div class="tab-pane " id="main_CT2" role="tabpanel">
																<div class="flatPanel panel panel-default">
																			<div class="row" style="">
																			<div class="form-group col-md-12 col-sm-12" style="height:100%">
																			<a href="/iris3/heatmap.php?jobid={{$jobid}}&file=12.json" target="_blank">
                                                                        <button type="button" class="btn btn-success" data-toggle="collapse" data-target="/iris3/heatmap.php?jobid={{$jobid}}&file=12.json">Open in new tab
                                                                        </button>
                                                                    </a>
																				<div id="heatmap">
																						<div id='container-id-12' style="height:95%;max-height:95%;max-width:100%;display:block">
																						<h1 class='wait_message'>Please wait ...</h1>
																					</div></div></div></div></div>

                                                            </div>	
															<div class="tab-pane " id="main_CT3" role="tabpanel">
																<div class="flatPanel panel panel-default">
																			<div class="row" style="">
																			<div class="form-group col-md-12 col-sm-12" style="height:100%">
																			
																				<div id="heatmap">
																						<div id='container-id-13' style="height:95%;max-height:95%;max-width:100%;display:block">
																						<h1 class='wait_message'>Please wait ...</h1>
																					</div></div></div></div></div>

                                                            </div>																
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
                                                <div class="col-sm-12">
                                                    <h3 style="text-align:center">Sankey Plot</h3>
                                                    <div id="myDiv"></div>
                                                    <!--<a href="data/{{$jobid}}/img/02.png" target="_blank"><img src="data/{{$jobid}}/img/02.png" style="margin:auto;display:block"></a> -->
                                                </div>

                                            </div>
                                        </div>

                                        <div class="tab-pane fade" id="tab2default">
                                            <div class="container">
                                                <div class="row">
                                                    <div class="col-md-11">
                                                        <ul class="nav nav-tabs" id="myTab" role="tablist">
                                                            <li class="nav-item active">
                                                                <a class="nav-link fade in active" id="home-tab" data-toggle="tab" href="#CT1" json="data/{{$jobid}}/mult_view1.json" root="#container-id-2" role="tab" aria-controls="home" aria-selected="true">CT1</a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a class="nav-link" id="profile-tab" data-toggle="tab" href="#CT2" json="data/{{$jobid}}/mult_view2.json" root="#container-id-3" role="tab" aria-controls="profile" aria-selected="false">CT2</a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a class="nav-link" id="contact-tab" data-toggle="tab" href="#CT3" json="data/{{$jobid}}/mult_view3.json" root="#container-id-4" role="tab" aria-controls="contact" aria-selected="false">CT3</a>
                                                            </li>
                                                        </ul>
                                                        <div class="tab-content" id="myTabContent">
                                                            <div class="tab-pane active" id="CT1" role="tabpanel">

																
																<div class="flatPanel panel panel-default">
																			<div class="row" >
																			<div class="form-group col-md-12 col-sm-12" style="height:100%">
																		<a href="/iris3/data/2018111445745/20181103_CT_1_bic.regulon.txt" target="_blank">
                                                                        <button type="button" class="btn btn-success" data-toggle="collapse" data-target="/html/iris3/data/2018111445745/20181103_CT_1_bic.regulon.txt">Download CT-1
                                                                        </button>
                                                                    </a>
																	<table id="motiftable" class="table table-striped table-bordered table-sm" cellpadding="0" cellspacing="0" width="100%">
                                                                    <thead>
                                                                        <tr>
                                                                            <th>Regulon</th>
                                                                            <th>Gene</th>

                                                                        </tr>
                                                                    </thead>
                                                                    <tbody>
                                                                        {{section name=sec1 loop=$regulon_result}}
                                                                        <tr>
                                                                            <td style="width:260px">
                                                                                <div class="col-sm-12">
                                                                                    <span style="font-size:14pt;">Regulon-{{$regulon_result[sec1][0]}}</span><br>
																					<span><a href="motif_detail.php?jobid=20160821183643f&id=1" target="_blank"><img src="data/{{$jobid}}/logo.png" style="margin:auto;display:block"></a></span>
                                                                                </div>
                                                                            </td>
                                                                            <td>

                                                                                <div style="height:100px; overflow-x: scroll;overflow-y: scroll;width:100%; font-size:14px;">
																				Gene name: 
                                                                                    {{section name=sec2 start=1 loop=$regulon_result[sec1]}}
                                                                                    <a  target="_blank" href= "https://www.genecards.org/cgi-bin/carddisp.pl?gene={{$regulon_result[sec1][sec2]}}" style="font-size:14px; display: inline-block;">{{$regulon_result[sec1][sec2]}}&nbsp;</a>{{/section}}
																					<br>Gene ID:<br>Transcript: 
																					
                                                                                </div>

                                                                            </td>
                                                                        </tr>
																		<tr >
																		<td colspan=2>
																						<div id="heatmap">
																						<div id='container-id-2' style="height:95%;max-height:95%;max-width:100%;display:block">
																						<h1 class='wait_message'>Loading heatmap ...</h1>
																					</div></div>
																					</td>
																		</tr>

                                                                        {{/section}}
                                                                    </tbody>
                                                                </table>

																					
																					</div></div></div>

                                                            </div>
															<div class="tab-pane " id="CT2" role="tabpanel">

																

																<div class="flatPanel panel panel-default">
																			<div class="row" >
																			<div class="form-group col-md-12 col-sm-12" style="height:100%">
																		<a href="/iris3/data/2018111445745/20181103_CT_1_bic.regulon.txt" target="_blank">
                                                                        <button type="button" class="btn btn-success" data-toggle="collapse" data-target="/html/iris3/data/2018111445745/20181103_CT_1_bic.regulon.txt">Download CT-1
                                                                        </button>
                                                                    </a>
																	<table id="motiftable" class="table table-striped table-bordered table-sm" cellpadding="0" cellspacing="0" width="100%">
                                                                    <thead>
                                                                        <tr>
                                                                            <th>Regulon</th>
                                                                            <th>Gene</th>

                                                                        </tr>
                                                                    </thead>
                                                                    <tbody>
                                                                        {{section name=sec1 loop=$regulon_result}}
                                                                        <tr>
                                                                            <td style="width:260px">
                                                                                <div class="col-sm-12">
                                                                                    <span style="font-size:14pt;">Regulon-{{$regulon_result[sec1][0]}}</span><br>
																					<span style="font-size:14pt;">MotifLogo</span>
                                                                                </div>
                                                                            </td>
                                                                            <td>

                                                                                <div style="height:100px; overflow-x: scroll;overflow-y: scroll;width:100%; font-size:14px;">
																				<!--Gene name: 
                                                                                    {{section name=sec2 start=1 loop=$regulon_result[sec1]}}
                                                                                    <a  target="_blank" href= "https://www.genecards.org/cgi-bin/carddisp.pl?gene={{$regulon_result[sec1][sec2]}}" style="font-size:14px; display: inline-block;">{{$regulon_result[sec1][sec2]}}&nbsp;</a>{{/section}}
																					<br>Gene ID:<br>Transcript: -->
																					
                                                                                </div>

                                                                            </td>
                                                                        </tr>
																		<tr >
																		<td colspan=2>
																						<div id="heatmap">
																						<div id='container-id-3' style="height:95%;max-height:95%;max-width:100%;display:block">
																						<h1 class='wait_message'>Loading heatmap ...</h1>
																					</div></div>
																					</td>
																		</tr>

                                                                        {{/section}}
                                                                    </tbody>
                                                                </table>

																					
																					</div></div></div>

                                                            </div>		
															<div class="tab-pane " id="CT3" role="tabpanel">
                                                                    
																
																<div class="flatPanel panel panel-default">
																			<div class="row" style="">
																			<div class="form-group col-md-12 col-sm-12" style="height:100%">
																			<a href="/iris3/data/2018111445745/20181103_CT_1_bic.regulon.txt" target="_blank">
                                                                        <button type="button" class="btn btn-success" data-toggle="collapse" data-target="/html/iris3/data/2018111445745/20181103_CT_1_bic.regulon.txt">Download CT-1
                                                                        </button>
                                                                    </a>
																				<div id="heatmap">
																						<div id='container-id-4' style="height:95%;max-height:95%;max-width:100%;display:block">
																						<h1 class='wait_message'>Please wait ...</h1>
																					</div></div></div></div></div>

                                                            </div>		
                                                            
															
															
															
<!--                                                             <div class="tab-pane fade" id="CT2" role="tabpanel" aria-labelledby="profile-tab">
                                                                <div class="result" border="1">
                                                                    <a href="/iris3/data/2018111445745/20181103_CT_1_bic.regulon.txt" target="_blank">
                                                                        <button type="button" class="btn btn-success" data-toggle="collapse" data-target="/html/iris3/data/2018111445745/20181103_CT_1_bic.regulon.txt">Download CT-2
                                                                        </button>
                                                                    </a>
                                                                </div>
                                                                <div id='container-id-3' style="height:95%;max-height:95%; max-width:100%">
                                                                    <h1 class='wait_message'>Please wait ...</h1>
                                                                </div>
                                                            </div>
                                                            <div class="tab-pane fade" id="CT3" role="tabpanel" aria-labelledby="contact-tab">
                                                                <div class="result" border="1">
                                                                    <a href="/iris3/data/2018111445745/20181103_CT_1_bic.regulon.txt" target="_blank">
                                                                        <button type="button" class="btn btn-success" data-toggle="collapse" data-target="/html/iris3/data/2018111445745/20181103_CT_1_bic.regulon.txt">Download CT-3
                                                                        </button>
                                                                    </a>
                                                                </div>
                                                                <hr />
                                                                <div id='container-id-4' style="height:95%;max-height:95%; max-width:100%">
                                                                    <h1 class='wait_message'>Please wait ...</h1>
                                                                </div>

                                                                
                                                            </div> -->
                                                        </div>

                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="tab-pane fade" id="tab3default">
                                            <div class="container">
                                                <div class="row">
                                                    <div class="col-12 col-md-12">
                                                        <button type="button" class="btn btn-success" data-toggle="collapse" data-target="#{{$annotation[sec1].Motifname}}_gene">Download All Files
                                                        </button>
                                                    </div>
                                                    <br>
                                                    <br>
                                                    <div class="col-12 col-md-12">
                                                        <button type="button" class="btn btn-success" data-toggle="collapse" data-target="#{{$annotation[sec1].Motifname}}_gene">Filtered Expression Matrix
                                                        </button>
                                                        <button type="button" class="btn btn-success" data-toggle="collapse" data-target="#{{$annotation[sec1].Motifname}}_gene">Bicluster Matrices
                                                        </button>
                                                        <button type="button" class="btn btn-success" data-toggle="collapse" data-target="#{{$annotation[sec1].Motifname}}_gene">CTS-Biclusters
                                                        </button>
                                                        <button type="button" class="btn btn-success" data-toggle="collapse" data-target="#{{$annotation[sec1].Motifname}}_gene">Cell type prediction
                                                        </button>
                                                        <button type="button" class="btn btn-success" data-toggle="collapse" data-target="#{{$annotation[sec1].Motifname}}_gene">CTS-Regulon
                                                        </button>
                                                        <button type="button" class="btn btn-success" data-toggle="collapse" data-target="#{{$annotation[sec1].Motifname}}_gene">Final Report
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
                    {{else}} {{block name="meta"}}
                    <META HTTP-EQUIV="REFRESH" CONTENT="15"> {{/block}}

                    <div style="text-align: left;">
                        <p>

                            <img src="static/images/busy.gif" />
                            <br /> Your request is received now.
                            <br> You can remember your jobid <font color="red"> <strong>{{$jobid}}</strong> </font>
                            <br> Or you can choose to stay at this page, which will be automatically refreshed every <b>15</b> seconds.
                            <br/> Link:&nbsp
                            <a href="{{$LINKPATH}}iris3/results.php?jobid={{$jobid}}">http://http://bmbl.sdstate.edu/{{$LINKPATH}}iris3/results.php?jobid={{$jobid}}</a></p>
                        <strong>We recommend you to cite the following papers:</strong>
                        <p>paper 1</p>
                        <p>paper 2</p>
                    </div>
                    {{/if}}
                </div>
            </div>
        </div>
    </div>
    <!-- Required JS Libraries -->
    <script src="assest/js/d3.js"></script>
    <script src="assest/js/underscore-min.js"></script>

    <!-- Clustergrammer JS -->
    <script src='assest/js/clustergrammer.js'></script>

    <!-- optional modules -->
    <script src='assest/js/Enrichrgram.js'></script>
    <script src='assest/js/hzome_functions.js'></script>
    <script src='assest/js/send_to_Enrichr.js'></script>

    <!-- make clustergram -->
    <script src='assest/js/load_clustergram.js'></script>

    <script>
        var data = {
            type: "sankey",
            orientation: "h",
            node: {
                pad: 10,
                thickness: 30,
                line: {
                    color: "black",
                    width: 2
                },
                label: ["1", "2", "3", "4", "5", "6", "7", "C1", "C2", "C3", "C4", "C5", "C6", "C7"],
                color: 'RdBu'
            },

            link: {
                source: [0, 1, 2, 3, 4, 4, 5, 5, 6, 6],
                target: [9, 9, 9, 9, 11, 12, 10, 12, 7, 8],
                value:  [3, 3, 6, 12, 16, 4, 14, 2, 22, 8]
            }
        }

        var data = [data]

        var layout = {
            font: {
                size: 16
            }
        }

        Plotly.react('myDiv', data, layout)


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
</main>
{{/block}}