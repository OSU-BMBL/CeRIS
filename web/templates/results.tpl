{{extends file="base.tpl"}}
{{block name="extra_js"}}

{{/block}}
{{block name="extra_style"}}

{{/block}}
{{block name="main"}}


<!-- Latest compiled and minified plotly.js JavaScript -->
<script src="https://cdn.plot.ly/plotly-latest.min.js"></script>

<!-- OR use a specific plotly.js release (e.g. version 1.5.0) -->
<script src="https://cdn.plot.ly/plotly-1.5.0.min.js"></script>

<!-- OR an un-minified version is also available -->
<script src="https://cdn.plot.ly/plotly-latest.js" charset="utf-8"></script>
<script>
 $(document).ready(function () {
  $('#motiftable').DataTable({
	"order": [[ 2, "asc" ]]
  });
  $('.dataTables_length').addClass('bs-select');
  
});

</script>

<main role="main" class="container">
   <div id="content">
	
      <div class="container">
	  	<br/>
         <div class="flatPanel panel panel-default">
            <div class="flatPanel panel-heading">job ID: 20181124190953</div>
            <div class="panel-body">
			{{if $status == "1"}}
               <div class="flatPanel panel panel-default">
                  <div class="panel-body">
                     <div class="col-md-12 col-sm-12">
                        <div class="form-group col-md-6 col-sm-6">
                           <label for="reportsList">Species: Human</label>
                        </div>
                        <div class="form-group col-md-6 col-sm-6">
                           <label>Number of Cells: 90</label>
                        </div>
                        <div class="form-group col-md-6 col-sm-6">
                           <label>Number of Genes: 20414</label>
                        </div>
                        <div class="form-group col-md-6 col-sm-6">
                           <label>Number of Filtered Genes: 6783</label>
                        </div>
                        <div class="form-group col-md-6 col-sm-6">
                           <label>Filtering Rate: 34%</label>
                        </div>
                        <div class="form-group col-md-6 col-sm-6">
                           <label>Number of Predicted Cell Types: 6</label>
                        </div>
                        <div class="form-group col-md-6 col-sm-6">
                           <label>Cell Label: Yes</label>
                        </div>
                        <div class="form-group col-md-6 col-sm-6">
                           <label>Total Biclusters: 42</label>
                        </div>
                        <div class="form-group col-md-6 col-sm-6">
                           <label>Number of Regulons: 33</label>
                        </div>
						<div class="form-group col-md-12 col-sm-12">
                           <a href="/iris3/main_hm.png" target="_blank"><img src="/iris3/main_hm.png" style="margin:auto;display:block"></a> 
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
            <!-- Nav tabs category -->
            <ul class="nav nav-tabs faq-cat-tabs">
                <li class="active"><a href="#faq-cat-2" data-toggle="tab">CT 1</a></li>
            </ul>
    
            <!-- Tab panes -->
            <div class="tab-content faq-cat-content">
                <div class="tab-pane active in fade" id="faq-cat-2">
                    <div class="panel-group" id="accordion-cat-2">
                        <div class="panel panel-default panel-faq">
						                                                                  <div class="result" border="1">
                                                          
                                                                                                         
                                          <a href="/iris3/data/2018111445745/20181103_CT_1_bic.regulon.txt" target="_blank" ><button type="button" class="btn btn-success" data-toggle="collapse" 
                                             data-target="/html/iris3/data/2018111445745/20181103_CT_1_bic.regulon.txt">Download CT-1 regulon 1
                                          </button></a>
                                                                  </div>
																  <hr />
										<div class="col-sm-10">
                                       <h3 style="text-align:center">Heatmap CT1</h3>
									   <div id="hm1"></div>
                                    </div> 
									<div class="col-sm-10">
                                       <h3 style="text-align:center">Heatmap CT2</h3>
									   <div id="hm2"></div>
                                    </div>
									<hr/>
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
										<td style="width:160px">
<div class="col-sm-12">
										   <span style="font-size:14pt;">Motif-{{$regulon_result[sec1][0]}}</span></a>
</div>
										</td>
<td >
 
<div style="height:200px;overflow-y:scroll; overflow-x: scroll;width:100%; font-size:14px;">
{{section name=sec2 start=1 loop=$regulon_result}}
	<span style="font-size:20pt;">{{$regulon_result[sec1][sec2]}}</span></a><br>
	{{/section}}
</div>

		</td>
									 </tr>


								  {{/section}}
								  </tbody>
							</table>
							<!--
                            <div class="panel-heading">
                                <a data-toggle="collapse" data-parent="#accordion-cat-2" href="#faq-cat-2-sub-1">
                                    <h4 class="panel-title">
                                        Regulon 1
                                        <span class="pull-right"><i class="glyphicon glyphicon-plus"></i></span>
                                    </h4>
                                </a>
                            </div>
                            <div id="faq-cat-2-sub-1" class="panel-collapse collapse">
                                <div class="panel-body">




                            </div>
                        </div>
<<<<<<< HEAD
                    </div>
                    <div class="flatPanel panel panel-default">
                        <div class="panel-body">
                            <div class="row" style="">
                                <div class="form-group col-md-12 col-sm-12" style="height:100%">
                                    <h3>CTS Cell-Gene-Regulon Heatmap</h3>
									     <ul class="nav nav-tabs" id="myTab" role="tablist">
                                                            <li class="nav-item active">
                                                                <a class="nav-link fade in active" id="home-tab" data-toggle="tab" href="#main_CT1" json="data/{{$jobid}}/ct1.json" root="#container-id-11" role="tab" aria-controls="home" aria-selected="true">Cell Type1</a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a class="nav-link" id="profile-tab" data-toggle="tab" href="#main_CT2" json="data/{{$jobid}}/ct2.json" root="#container-id-12" role="tab" aria-controls="profile" aria-selected="false">Cell Type2</a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a class="nav-link" id="contact-tab" data-toggle="tab" href="#main_CT3" json="data/{{$jobid}}/ct3.json" root="#container-id-13" role="tab" aria-controls="contact" aria-selected="false">Cell Type3</a>
                                                            </li>
                                                        </ul>
                                                        <div class="tab-content" id="myTabContent">
														<div class="tab-pane active" id="main_CT1" role="tabpanel">
																<div class="flatPanel panel panel-default">
																			<div class="row" style="">
																			<div class="form-group col-md-12 col-sm-12" style="height:100%">
																			<a href="/iris3/heatmap.php?jobid={{$jobid}}&file=ct1.json" target="_blank">
                                                                        <button type="button" class="btn btn-success" data-toggle="collapse" data-target="/iris3/heatmap.php?jobid={{$jobid}}&file=ct1.json">Open in new tab
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
																			<a href="/iris3/heatmap.php?jobid={{$jobid}}&file=ct2.json" target="_blank">
                                                                        <button type="button" class="btn btn-success" data-toggle="collapse" data-target="/iris3/heatmap.php?jobid={{$jobid}}&file=t2.json">Open in new tab
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
=======
                        <div class="panel panel-default panel-faq">
                            <div class="panel-heading">
                                <a data-toggle="collapse" data-parent="#accordion-cat-1" href="#faq-cat-1-sub-2">
                                    <h4 class="panel-title">
                                        Regulon 2
                                        <span class="pull-right"><i class="glyphicon glyphicon-plus"></i></span>
                                    </h4>
                                </a>
>>>>>>> parent of 3a6d8ee... front-end update
                            </div>
                            <div id="faq-cat-2-sub-2" class="panel-collapse collapse">
                                <div class="panel-body">
<<<<<<< HEAD
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
																					<span><a href="motif_detail.php?jobid=20181124190953&id=1" target="_blank"><img src="data/{{$jobid}}/20181124190953Motif-1.png" style="margin:auto;display:block"></a></span>
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
=======
                                   </div>
>>>>>>> parent of 3a6d8ee... front-end update
                            </div>
                        </div> -->
                    </div>
                </div>
			</div>			
            </div>
          </div>
        </div>
    </div></div>
	

                            <div class="tab-pane fade" id="tab3default">
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
			   {{else}}
			     {{block name="meta"}}
  <META HTTP-EQUIV="REFRESH" CONTENT="15">
  {{/block}}
  

     <div style="text-align: left;"><p>
  
    <img src="static/images/busy.gif" /> <br />
  
    Your request is received now.<br>
	You can remember your jobid <font color="red"> <strong>{{$jobid}}</strong> </font><br>
    Or you can choose to stay at this page, which will be automatically refreshed every <b>15</b> seconds.<br/>    
    Link:&nbsp<a href ="{{$LINKPATH}}iris3/results.php?jobid={{$jobid}}">http://http://bmbl.sdstate.edu/{{$LINKPATH}}iris3/results.php?jobid={{$jobid}}</a></p>     
     <strong>We recommend you to cite the following papers:</strong>
	 <p>paper 1</p>
	 <p>paper 2</p>
			   </div>
			   {{/if}}
            </div>
         </div>
      </div>
   </div>
   									
<script>
var data = {
  type: "sankey",
  orientation: "h",
  node: {
    pad: 18,
    thickness: 30,
    line: {
      color: "black",
      width: 1
    },
   label: ["1", "2", "3", "4", "5", "6", "7","C1", "C2", "C3", "C4", "C5", "C6", "C7"],
   color: 'RdBu'
      },

  link: {
    source: [0,1,2,3,4,5,6],
    target: [7,8,9,10,11,12,13],
    value:  [3,3,6,12,20,16,30]
  }
}

var data = [data]

var layout = {
  font: {
    size: 14
  }
}

function makeplot() {
  Plotly.d3.csv("/iris3/heat_matrix.txt", function(data){ processData(data) } );

};

function processData(allRows) {

  console.log(allRows);
  var x = [], y = [], z = [],keys=[];

  for (var i=0; i<allRows.length; i++) {
    row = allRows[i];

	var keys = $.map(row, function(v, i){
	return i;
	});
	
	for (var j=0; j<keys.length; j++) {
		x.push( row[''] );
		y.push( keys[j] );
		z.push( row[j]);
	}
  }
  console.log( 'X',x, 'Y',y, 'Value',z );
  makePlotly( x, y, z );
}

function makePlotly( x, y, z ){
  var plotDiv = document.getElementById("heatmap");
  var traces = [{
    x: x,
    y: y,
	z: z
  }];

  Plotly.newPlot('hm1', traces,
    {title: 'Plotting CSV data from AJAX call'});
};

makeplot();
Plotly.react('myDiv', data, layout)

var data_hm2 = [
  {
    z: [[1, 20, 30, 50, 1], [20, 1, 60, 80, 30], [30, 60, 1, -10, 20]],
    x: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
    y: ['Morning', 'Afternoon', 'Evening'],
    type: 'heatmap'
  }
];
Plotly.newPlot('hm2', data_hm2);
Plotly.newPlot('myDiv', data);

</script>
</main>
{{/block}}