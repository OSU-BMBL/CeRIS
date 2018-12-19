
{{extends file="base.tpl"}}
{{block name="extra_style"}}
form div.fieldWrapper label { min-width: 5%; }
{{/block}}
{{block name="extra_js"}}
{{/block}}
{{block name="main"}}
<script> 
    $(document).ready(function() {
	$('#upload_label').hide();
    $('.selectpicker').selectpicker();
     $('#tooltip1').tooltip();
     $('[data-toggle="tooltip"]').tooltip({
           placement : 'top'
       });
    $('.dropdown-toggle').dropdown();
	
dropzone = $("#dropzone_exp").dropzone({ 
	dictDefaultMessage: "Drag and drop your gene expression file here, or click to browse and upload it. <br> Accepted files: .txt,.csv,.tsv,.xls,.xlsx",
	acceptedFiles: ".txt,.csv,.tsv,.xls,.xlsx",
	url: "upload.php",
	maxFiles: 1,
	maxFilesize: 500,
	maxfilesexceeded: function(file) {
        this.removeAllFiles();
        this.addFile(file);
    },
	sending: function(file, xhr, formData){
        formData.append('filetype', 'dropzone_exp');
    },
    success: function(file, response){
	$('#submit_btn').attr("disabled", false);
    	response = JSON.parse(response);
		console.log(response);
		
    	addTable(response);
		
    }
});
	
	$("div#dropzone_label").dropzone({ 
	dictDefaultMessage: "Drag and drop your cell label file here, or click to browse and upload it. <br> Accepted files: .txt,.csv,.tsv,.xls,.xlsx",
	acceptedFiles: ".txt,.csv,.tsv,.xls,.xlsx",
	url: "upload.php",
	maxFiles: 1,
	maxFilesize: 500,
	maxfilesexceeded: function(file) {
        this.removeAllFiles();
        this.addFile(file);
    },
	sending: function(file, xhr, formData){
        formData.append('filetype', 'dropzone_label');
    },
    success: function(file, response){
    	response = JSON.parse(response);
		console.log(response);
    	addTable(response);
		
    }
	});
	
   });
    function displayForm(c) {
        if (c.value == "1") {
			$('#upload_label').hide();
            //document.getElementById("upload_label").style.visibility = 'hidden';
        } else if (c.value == "2") {
			$('#upload_label').show();	
            //document.getElementById("upload_label").style.visibility = 'visible';
        } else {}
    }
	
 $(document).on('click', '.remove_image', function(){
  var name = $(this).attr('id');
  $.ajax({
   url:"upload.php",
   method:"POST",
   data:{name:name},
   success:function(data)
   {
    list_image();
   }
  })
 });
 
	function display_preview()
 {
  $.ajax({
   url:"upload.php",
   success:function(data){
    $('#preview').html(data);
   }
  });
 }

 var addTable = function(dataset) {
alert("message successfully sent")
	// Save data
	$('#expression').val(JSON.stringify(dataset));

	// Toggle Interfaces
	$('button[form="upload-expression-form"]').prop('disabled', false);
	$('button[form="upload-expression-form"]').toggleClass('black white bg-white bg-blue');
	$('#dropzone_exp').hide();
	//$('#formats').hide();
	addPreviewTable(dataset, true);
	$('#intro').html('The uploaded dataset contains <span class="highlight">'+dataset['columns'].length+' samples</span> and <span class="highlight">'+dataset['index'].length+' genes</span>. Check that the preview below is correct, then click Continue to proceed.')
}

// Initialize Dropzone

function goBack() {
    window.history.back();
}

// Tooltip and Popover
$('[data-toggle="tooltip"]').tooltip(); 
$('[data-toggle="popover"]').popover(); 

// Card Collapse Info
// $('.info-toggle').click(function(evt) {
// 	evt.preventDefault();
// 	var $button = $(evt.target),
// 		$icon = $button.parents('label').find('i'),
// 		id = $button.parents('label').attr('for');
// 	$('#'+id+'-info').collapse('toggle');
// 	$icon.toggleClass('fa-chevron-down').toggleClass('fa-chevron-up');
// })

// Preview Table
function addPreviewTable(response, metadata=true) {

	// Define table
	var $table = $('<table>', {'class': 'table-striped w-100'}).append($('<thead>').append($('<tr>', {'class': 'very-small text-center border-grey border-left-0 border-right-0'}))).append($('<tbody>'));

	// Add headers
	label = metadata ? 'Gene' : 'Sample'
	$table.find('tr').append($('<th>', {'class': 'px-2 py-1'}).html(label));
	$.each(response['columns'], function(i, col) {
		$table.find('tr').append($('<th>', {'class': 'px-2 py-1'}).html(col));
	})

	// Get row number
	n = metadata ? 6 : response['index'].length

	// Add rows
	for (i=0; i<n; i++) {
		var $tr = $('<tr>').append($('<td>', {'class': 'bold text-center px-2 py-1'}).html(response['index'][i]));
		$.each(response['data'][i], function(i, val) {
			$tr.append($('<td>', {'class': 'light text-center tiny'}).html(val));
		})
		$table.find('tbody').append($tr);
	}

	// Add
	$('#loader').addClass('d-none');
	$('#preview').append($table).removeClass('d-none');
}

// Serialize table
function serializeTable($table) {
	// Initialize results
	var data = [];

	// Loop through rows
	$table.find('tr').each(function(i, tr) {

		// Get cells
		var cells = i === 0 ? $(tr).find('th') : $(tr).find('td');

		// Get values
		var values = [];
		$.each(cells, function(i, cell) {
			var value = $(cell).find('input').length ? $(cell).find('input').val() : $(cell).html();
			values.push(value);
		})

		// Append values
		data.push(values);
	})

	// Return data
	return data
}

// Array difference
Array.prototype.diff = function (a) {
    return this.filter(function (i) {
        return a.indexOf(i) === -1;
    });
};
 
</script>
<main role="main" class="container">
   <hr>
   <!--<div class="starter-template">-->
   <form method="POST" action="{{$URL}}" encType="multipart/form-data" id="needs-validation">
      <h2 class="text-center">Job Submission</h2>                        
      <div class="form-group row">
         <div class="form-check col-sm-8 ">
            <label class="form-check-label" for="expfile">Upload gene expression file: <span class="glyphicon glyphicon-question-sign" data-toggle="tooltip" data-original-title="A normal gene expression file with genes as rows and cells as columns. Users should normalize and filter the data before the submission. Accept both txt and csv format. "> </span></label> 
         </div>
    <div class="form-check col-sm-8  ">
      <div class="dropdown" >
        <button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true" style="border:1px solid #c9c9c9;border-radius:.25rem!important">
          Example <span class="caret"></span>
        </button>
        <ul class="dropdown-menu" aria-labelledby="dropdownMenu1">
          <li><a class="dropdown-item" href="#">Load Example</a></li>
          <li><a class="dropdown-item" href="/biojupies/app/static/data/biojupies_example_matrix.txt" download>Download Example File</a></li>
        </ul>
      </div>

  </div>
         <div class="col-sm-12">
		 <div id="dropzone_exp"  class="dropzone border-grey rounded dz-clickable" style="background-image: url(assest/img/expression_table.png); background-size: 100% 100%;margin:10px 0 0 0;border:1px solid #c9c9c9;border-radius:.25rem!important"></div>

				

</div>

		 	<div id="loader" class="mt-2"></div>
			<div id="preview" class="mt-2 d-none"></div>
			<!--<a style="padding:0px;" class="btn btn-link" href="/iris3/program/Yan_expression.csv" role="button">Download example expression file</a>
</form>-->
         
		 
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
      
      <hr>
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
                                 <div class="col-md-2">
                                    <label for="ex1">Consistancy level: <span class="glyphicon glyphicon-question-sign" data-toggle="tooltip" data-original-title="Parameter in QUBIC that affect the consistancy level of a bicluster. Lower value allows more genes included during the growth of bicluster and 1 means no growth. Default is 1. "> </span> </label>
                                 </div>
                                 <div class="col-md-2">
                                    <select class="selectpicker" name="c_arg" data-width="auto">
                                       <option>0.5</option>
                                       <option>0.6</option>
                                       <option>0.7</option>
									   <option>0.8</option>
									   <option>0.9</option>
									   <option data-subtext="Default" selected="selected">1.0</option>
                                    </select>
                           </div>
                        </div>
						<br>
                        <div class="row">
                           <div class="col-md-2">
                              <label for="ex3">Max biclusters: <span class="glyphicon glyphicon-question-sign" data-toggle="tooltip" data-original-title="Max number of biclusters to output. Note: the output number will affect the prediction of bicluster, not merely a cutoff, and the output biclusters may less than this number. Default is 100."> </span></label>
                           </div>
                           <div class="col-md-2">
                              <select class="selectpicker" name="o_arg" data-width="auto">
                                       <option>20</option>
                                       <option>50</option>
                                       <option data-subtext="Default" selected="selected">100</option>
									   <option>200</option>
                              </select>
                           </div>
                        </div>
						<br>
                        <div class="row">
                           <div class="col-md-2">
                              <label for="ex2">Overlap rate: <span class="glyphicon glyphicon-question-sign" data-toggle="tooltip" data-original-title="Controls the level of overlaps between to-be-identified biclusters. 0 means no overlap and 1 means complete overlap. Default is 0.5."> </span></label>
                           </div>
                           <div class="col-md-2">
                              <select class="selectpicker" name="f_arg" data-width="auto">
									   <option>0</option>
									   <option>0.1</option>
									   <option>0.2</option>
									   <option>0.3</option>
									   <option>0.4</option>
                                       <option data-subtext="Default" selected="selected">0.5</option>
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
					 <div id="upload_label">
					 <div class="form-group row">
         <div class="form-check col-sm-1 ">
            <label class="form-check-label" for="cellinfo">Upload cell label: <span class="glyphicon glyphicon-question-sign" data-toggle="tooltip" data-original-title="A table contains cell infomation. The file should includes a cell names in the first column match with the expression file, and the second column indicating the cell clusters. Cell clusters are used in two ways: (i) assess the cell-type prediction results from SC3, and (ii) assign Cell-type-specific (complex) regulons. If no cell label file uploaded, the pipeline will automatically use the predicted clusters from SC3 for the following regulon predictions. Accept both txt and csv format."> </span></label>
         </div>
         <div class="col-sm-4">
		       <div class="dropdown" >
        <button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true" style="border:1px solid #c9c9c9;border-radius:.25rem!important">
          Example <span class="caret"></span>
        </button>
        <ul class="dropdown-menu" aria-labelledby="dropdownMenu1">
          <li><a class="dropdown-item" href="#">Load Example</a></li>
          <li><a class="dropdown-item" href="/iris3/program/Yan_cell_label.csv" download>Download Example File</a></li>
        </ul>
      </div>
		 <div id="dropzone_label"  class="dropzone border-grey rounded dz-clickable" style="background-image: url(assest/img/expression_table.png); background-size: 100% 100%;margin:0;border:1px solid #c9c9c9;border-radius:.25rem!important">
         </div>

      </div>
      </div></div>
                  </div>
                  <br>
                  <h4 class="font-italic text-left">CTS-regulon prediction <span class="glyphicon glyphicon-question-sign" data-html="true" data-toggle="tooltip" data-original-title="Regulon: a group of genes that controlled by the same regulatory gene.<br>
CTS-regulon: A group of genes controlled by ONE motif under the same cell type. Genes can repeated show up in multiple regulons. <br>
 One regulon refers to multiple gene groups found in one bicluster under the same cell type."> </span></h4>
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
         <button type="submit" id="submit_btn" disabled= "true" class="btn btn-primary" name="submit" value="submit">Submit</button>
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