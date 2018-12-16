{{extends file="base.tpl"}}
{{block name="extra_style"}}
form div.fieldWrapper label { min-width: 5%; }
{{/block}}
{{block name="extra_js"}}
{{/block}}
{{block name="main"}}
<script>
   $(document).ready(function() {
   $('.selectpicker').selectpicker();
     $('#tooltip1').tooltip();
     $('[data-toggle="tooltip"]').tooltip({
           placement : 'top'
       });
   $('.dropdown-toggle').dropdown();
	$("div#dropzone_exp").dropzone({ 
	url: "upload.php",
	dictDefaultMessage: "Drag or drop your file here, or click to browse and upload it.",
	maxFiles: 1,
	maxfilesexceeded: function(file) {
        this.removeAllFiles();
        this.addFile(file);
    }
	});
   });
          function displayForm(c) {
        if (c.value == "1") {

            document.getElementById("upload_label").style.visibility = 'hidden';
        } else if (c.value == "2") {

            document.getElementById("upload_label").style.visibility = 'visible';
        } else {}
    }

</script>
<main role="main" class="container">
   <hr>
   <!--<div class="starter-template">-->
   <form method="POST" action="{{$URL}}" encType="multipart/form-data" id="needs-validation">
      <h2 class="text-center">Job Submission</h2>
	  <form action="upload.php" class="dropzone"></form>                            
      <div class="form-group row">
         <div class="form-check col-sm-3 ">
            <label class="form-check-label" for="expfile">Upload gene expression file: <span class="glyphicon glyphicon-question-sign" data-toggle="tooltip" data-original-title="A normal gene expression file with genes as rows and cells as columns. Users should normalize and filter the data before the submission. Accept both txt and csv format. "> </span></label> <a style="padding:0px;" class="btn btn-link" href="/iris3/program/Yan_expression.csv" role="button">Download example expression file</a>
         </div>
         <div class="col-sm-12">
		 <div id="dropzone_exp"  class="dropzone border-grey rounded dz-clickable" style="background-image: url(assest/img/expression_table.png); background-size: 100% 100%;margin:20px 0;border:1px solid #c9c9c9;border-radius:.25rem!important">
</form>
         </div>
      </div>

      <div class="form-group row">
         <div class="form-check col-sm-12 ">
            <input class="form-check-input" type="checkbox" name="allowstorage" id="allowstorage" value="0">
            <label class="form-check-label" for="allowstorage">Allow data storage in our database <span class="glyphicon glyphicon-question-sign" data-toggle="tooltip" data-original-title="To check this option, you allow us to store your data in IRIS3 database (both submitted and results) for the future database construction. Be cautious if your data have not been published."> </span></label>
         </div>
      </div>
      <div class="form-group row">
         <div class="form-check col-sm-12 ">
            <input class="form-check-input" type="checkbox" name="allowstorage" id="allowstorage" value="0" checked>
            <label class="form-check-label" for="allowstorage">Enable gene filtering (default: Yes) <span class="glyphicon glyphicon-question-sign" data-toggle="tooltip" data-original-title="The optional filtering step removes genes that are either expressed (expression value > 2) in less than 6% of cells or expressed (expression value > 0) in at least 96% of cells. The method was fully described in SC3 manuscript. The filtering will not affect the result of cell prediction nor the bicluster results, but only shorten the ruuning time."> </span></label>
         </div>
      </div>
      <!--<div class="form-group row">
         <label for="exampleFormControlSelect1">Example select</label>
           <select class="form-control col-sm-4" name="organism" id="exampleFormControlSelect1">
             <option>human</option>
             <option>mouse</option>
           </select>
         </div>
         <div class="form-group row">
             <div class="form-check col-sm-3 ">
               <input class="form-check-input " type="radio" name="radiotarget" id="usertarget" value="option1" checked>
               <label class="form-check-label" for="usertarget">Upload my own Target genes</label>
             </div>
             <div class="col-sm-5">
               <input type="file" class="form-control-file" id="targetfile" name="targetfile" required>
             </div>
         </div>
         <div class="form-group row">
             <div class="form-check col-sm-3 ">
               <input class="form-check-input" type="radio" name="radiotarget" id="autotarget" value="option2">
               <label class="form-check-label" for="autotarget">Derive Target genes automatically</label>
             </div>
             <div class="col-sm-6 row">
               <label class="col-sm-3"  for="targetnum">#Target genes: </label>
               <input type="text" class="form-control-file col-sm-2" id="targetnum" name="targetnum" disabled required>
             </div>
         </div>-->
      <hr>
      <!-- 
         <div class="bs-example">
         <div class="panel-group" id="accordion">
           <div class="panel panel-default">
               <div class="panel-collapse-heading">
                   <h4 class="panel-title">
                       <a data-toggle="collapse" data-parent="#accordion" href="#collapseThree">Advance parameters</a>
                   </h4>
               </div>
               <div id="collapseThree" class="panel-collapse collapse">
                   <div class="panel-body">
         <div class="form-check col-sm-7 ">
                     <input class="form-check-input" type="checkbox" name="radiotarget" id="autotarget" value="option2" checked="checked">
                     <p class="form" for="autotarget"> &nbsp;&nbsp;&nbsp;&nbsp;lowest expression value<input name="c_arg" type="text" id="c_arg" value=2 size="3">in less than <input name="c_arg" type="text" id="c_arg" value=6 size="3">% of cells</p>
                   </div>
         
         <div class="form-check col-sm-7 ">
                     <input class="form-check-input" type="checkbox" name="radiotarget" id="autotarget" value="option2" checked="checked">
                     <p class="form" for="autotarget"> &nbsp;&nbsp;&nbsp;&nbsp;Expression value in at least<input name="c_arg" type="text" id="c_arg" value=2 size="3">% of cells</p>
                   </div>
         <div class="form-check col-sm-7 ">
                     <label class="form-check-label" for="expfile">Upload custom annotation file:</label><input type="file" class="form-control-file" id="expfile" name="files" >
                   </div>
                 <h4 class="font-italic text-left">normalization method</h4>
              
                 <select class="form-control col-sm-4" name="normalization" id="exampleFormControlSelect1">
                   <option>Read count</option>
                   <option>UMI</option>
         <option>FPKM</option>
         <option>RPKM</option>
         <option>TPM</option>
                 </select>
         <br>
         
         
                   </div>
               </div>
           </div>
         </div>
         </div>-->
      <div class="bs-example2">
         <div class="panel-group" id="accordion2">
            <div class="panel panel-default">
               <div class="panel-collapse-heading">
                  <h4 class="panel-title">
                     <a data-toggle="collapse" data-parent="#accordion2" href="#collapseThree2">Advanced options</a>
                  </h4>
               </div>
               <div id="collapseThree2" class="panel-collapse collapse">
                  <div class="panel-body">
                     <h4 class="font-italic text-left">Biclustering parameters</h4>
                     <div class="form-group">
                        <div class="row">
                                 <div class="col-md-1">
                                    <label for="ex1">c <span class="glyphicon glyphicon-question-sign" data-toggle="tooltip" data-original-title="Parameter in QUBIC that affect the consistancy level of a bicluster. Lower value allows more genes included during the growth of bicluster and 1 means no growth. Default is 1. "> </span> </label>
                                 </div>
                                 <div class="col-md-2">
                                    <select class="selectpicker">
                                       <option>0.5</option>
                                       <option>0.6</option>
                                       <option>0.7</option>
									   <option>0.8</option>
									   <option>0.9</option>
									   <option selected="selected">1.0 (default)</option>
                                    </select>
                           </div>
                        </div>
						<br>
                        <div class="row">
                           <div class="col-md-1">
                              <label for="ex3">o <span class="glyphicon glyphicon-question-sign" data-toggle="tooltip" data-original-title="Max number of biclusters to output. Note: the output number will affect the prediction of bicluster, not merely a cutoff, and the output biclusters may less than this number. Default is 100."> </span></label>
                           </div>
                           <div class="col-md-2">
                              <select class="selectpicker">
                                       <option>20</option>
                                       <option>50</option>
                                       <option selected="selected">100 (default)</option>
									   <option>200</option>
                              </select>
                           </div>
                        </div>
						<br>
                        <div class="row">
                           <div class="col-md-1">
                              <label for="ex2">f <span class="glyphicon glyphicon-question-sign" data-toggle="tooltip" data-original-title="Controls the level of overlaps between to-be-identified biclusters. 0 means no overlap and 1 means complete overlap. Default is 0.5."> </span></label>
                           </div>
                           <div class="col-md-2">
                              <select class="selectpicker">
									   <option>0</option>
									   <option>0.1</option>
									   <option>0.2</option>
									   <option>0.3</option>
									   <option>0.4</option>
                                       <option selected="selected">0.5 (default)</option>
                                       <option>0.6</option>
                                       <option>0.7</option>
									   <option>0.8</option>
									   <option>0.9</option>
									   <option>1.0</option>
                              </select>
                           </div>
                        </div>
                     </div>
                  
                  <h4 class="font-italic text-left">CTS-bicluster inference <span class="glyphicon glyphicon-question-sign" data-toggle="tooltip" data-original-title="Choose the resource of cell types, either predicted from SC3 or the ground truth labels provided in the uploaded cell label file. The CTS-biclusters are determined by performing the hypergeometric test between the cells in each bicluster and in each cell type."> </span></h4>
                  <div class="row">
                     <div class="form-check col-sm-4 ">
                        <input type="radio" value="1" id="enable_sc3" name="customRadioInline4" class="custom-control-input" checked="" onClick="displayForm(this)">
                        <label class="custom-control-label" for="customRadioInline4">SC3 <span class="glyphicon glyphicon-question-sign" data-toggle="tooltip" data-original-title="A clustering based cell type prediction tool. Default parameters are used."> </span></label>
                     </div>
                     <div class="col-sm-2">
                        <input type="radio" value="2" id="enable_labelfile" name="customRadioInline4" class="custom-control-input" onClick="displayForm(this)">
                        <label class="custom-control-label" for="customRadioInline5" onchange="document.getElementById('labelfile').disabled = !this.checked;">Your cell label <span class="glyphicon glyphicon-question-sign" data-toggle="tooltip" data-original-title="User's uploaded ground truth cell labels, either numbers or factors."> </span></label>
                     </div>
					 <div id="upload_label" style="visibility:hidden">
					 <div class="form-group row">
         <div class="form-check col-sm-3 ">
            <label class="form-check-label" for="cellinfo">Upload cell label<span class="glyphicon glyphicon-question-sign" data-toggle="tooltip" data-original-title="A table contains cell infomation. The file should includes a cell names in the first column match with the expression file, and the second column indicating the cell clusters. Cell clusters are used in two ways: (i) assess the cell-type prediction results from SC3, and (ii) assign Cell-type-specific (complex) regulons. If no cell label file uploaded, the pipeline will automatically use the predicted clusters from SC3 for the following regulon predictions. Accept both txt and csv format."> </span></label>
         <input type="file" class="form-control-file" id="labelfile" name="labelfile" ><a class="btn btn-link" href="/iris3/program/Yan_cell_label.csv" role="button">Download example cell label file</a></div>

      </div></div>
                  </div>
                  <br>
                  <h4 class="font-italic text-left">CTS-(complex)-regulon prediction <span class="glyphicon glyphicon-question-sign" data-html="true" data-toggle="tooltip" data-original-title="Regulon: a group of genes that controlled by the same regulatory gene.<br>
CTS-regulon: A group of genes controlled by ONE motif under the same cell type. Genes can repeated show up in multiple regulons. <br>
CTS-complex-regulon: Non-overlapped group of genes that controlled by the same motif(s). One regulon refers to multiple gene groups found in one bicluster under the same cell type."> </span></h4>
                  <div class="row">
                     <div class="form-check col-sm-4 ">
                        <input type="radio" id="customRadioInline6" name="customRadioInline6" class="custom-control-input" checked="">
                        <label class="custom-control-label" for="customRadioInline6">DMINDA <span class="glyphicon glyphicon-question-sign" data-toggle="tooltip" data-original-title="Our in-house motif prediction tool."> </span></label>
                     </div>
                     <div class="col-sm-2">
                        <input type="radio" id="enable_labelfile" name="customRadioInline6" class="custom-control-input">
                        <label class="custom-control-label" for="customRadioInline6" >MEME <span class="glyphicon glyphicon-question-sign" data-toggle="tooltip" data-original-title="We integrated the MEME command line version as an option for motif prediction. Default parameters are used. "> </span></label>
                     </div>

                  </div>
               </div>
            </div>
         </div>
      </div>
      </div>
      <!--
         <div class="bs-example3">
             <div class="panel-group" id="accordion3">
                 <div class="panel panel-default">
                     <div class="panel-collapse-heading">
                         <h4 class="panel-title">
                             <a data-toggle="collapse" data-parent="#accordion" href="#collapseThree3">Cell type prediction options</a>
                         </h4>
                     </div>
                     <div id="collapseThree3" class="panel-collapse collapse">
                     <div class="panel-body">
         <h4 class="font-italic text-left">Cell type resource for CTS-bicluster assignment</h4>
         <div class="custom-control custom-radio custom-control-inline">
           <input type="radio" id="customRadioInline4" name="customRadioInline4" class="custom-control-input" checked="">
           <label class="custom-control-label" for="customRadioInline4">SC3</label>
         
         </div>
         <div class="custom-control custom-radio custom-control-inline">
           <input type="radio" id="customRadioInline5" name="customRadioInline4" class="custom-control-input">
           <label class="custom-control-label" for="customRadioInline5" onchange="document.getElementById('sendNewSms').disabled = !this.checked;">Your cell label</label>
         <div class="form-check col-sm-7 ">
          <label class="form-check-label" for="labelfile">Upload your cell label file:</label>
                           <input type="file" class="form-control-file" id="labelfile" name="labelfile" >
                         
         	</div>
         </div> 
         
         		  
                         </div>
                     </div>
                 </div>
             </div>
         </div>
         <div class="bs-example4">
             <div class="panel-group" id="accordion4">
                 <div class="panel panel-default">
                     <div class="panel-collapse-heading">
                         <h4 class="panel-title">
                             <a data-toggle="collapse" data-parent="#accordion" href="#collapseThree4">CTS-regulon prediction options</a>
                         </h4>
                     </div>
                     <div id="collapseThree4" class="panel-collapse collapse">
                     <div class="panel-body">
                     <h4 class="font-italic text-left">Option 4</h4>
                    <div class="form-group">
                       
                   </div>
         		  <br>
                         </div>
                     </div>
                 </div>
             </div>
         </div>
              -->                      
      <div id="emailfd" class="section" style="position:relative;top:10px;">
         &nbsp;&nbsp;Optional: Please leave your email below; you will be notified by email when the job is done.<br/>
         <div class = "bootstrap-iso" style = "margin-top: 5px;">
            &nbsp;
            <strong>E-mail</strong>&nbsp;:<input name="email" type="text" id="email" size="60" style="position:relative;left:10px; width : 30%;" pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,3}$"/>       
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
         </div>
      </div>
      <hr>
      <div class="form-group">
         <button type="submit" class="btn btn-primary" name="submit" value="submit">Submit</button>
         <a class="btn btn-info" href="/iris3/results.php?jobid=20181124190953" role="button">Example output</a>
      </div>
      <div class="form-group">
         <p id="words" class="hidden text-danger">Your job is running, don't close the browser tab, waiting time could vary from minutes to hour.</p>
      </div>
   </form>
   <!--</div>-->
   <hr>
       <script src='assest/js/dropzone.js'></script>
<link href="assest/css/dropzone.css" type="text/css" rel="stylesheet" />
</main>
{{/block}}