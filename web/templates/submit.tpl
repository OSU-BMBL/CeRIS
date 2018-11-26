{{extends file="base.tpl"}}

{{block name="extra_style"}}
  form div.fieldWrapper label { min-width: 5%; }
{{/block}}

{{block name="extra_js"}}

<script type="text/javascript">
  $J(function() {
    $J('div.accordion').accordion();
    $J('a#id_example').click(function () {
      $J.ajax({
        async : false, dataType : "json", url : "example_ajax.php",
        success : function(data) {
          $J('textarea#id_sequences').val(data);
        }
      });
    });
  });
   $('.panel-collapse').on('show.bs.collapse', function () {
    $(this).siblings('.panel-collapse-heading').addClass('active');
  });

  $('.panel-collapse').on('hide.bs.collapse', function () {
    $(this).siblings('.panel-collapse-heading').removeClass('active');
  });
  
</script>
<!-- Piwik -->

<!-- End Piwik Code -->
{{/block}}
<script>
$(document).ready(function () {
    $("#showcase").awShowcase({
        content_width: 900,
        content_height: 1000,
        auto: true,
        interval: 3000,
        continuous: false,
        arrows: true,
        buttons: true,
        btn_numbers: true,
        keybord_keys: true,
        mousetrace: false,
        /* Trace x and y coordinates for the mouse */
        pauseonover: true,
        stoponclick: false,
        transition: 'fade',
        /* hslide/vslide/fade */
        transition_delay: 0,
        transition_speed: 500,
        show_caption: 'onload'
		/* onload/onhover/show */
    });
});
</script>

</head>
{{block name="main"}}

<main role="main" class="container">

      <!--<div class="starter-template">-->
         <form method="POST" action="{{$URL}}" encType="multipart/form-data" id="needs-validation">
          <h2 class="text-center">Job Submission</h2>
      
	        <h3 class="font-italic text-left">Gene expression file</h3>

			<div class="form-group row">
                <div class="form-check col-sm-3 ">
                  <label class="form-check-label" for="expfile">Upload gene expression file:</label>
                </div>
                <div class="col-sm-5">
                  <input type="file" class="form-control-file" id="expfile" name="expfile" >
                
				</div>
            </div>
            <div class="form-group row">
				 <div class="form-check col-sm-3 ">
                  <input class="form-check-input" type="checkbox" name="allowstorage" id="allowstorage" value="0">
                  <label class="form-check-label" for="allowstorage"> &nbsp;&nbsp;&nbsp;&nbsp;Allow data storage in our database</label>
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
	  
	  

     
       
     
      <div class="bs-example">
    <div class="panel-group" id="accordion">
        <div class="panel panel-default">
            <div class="panel-collapse-heading">
                <h4 class="panel-title">
                    <a data-toggle="collapse" data-parent="#accordion" href="#collapseThree">Gene filtering options</a>
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
           <!--    <h3 class="font-italic text-left">normalization method</h3>
           <div class="form-group">
              <select class="form-control col-sm-4" name="normalization" id="exampleFormControlSelect1">
                <option>Read count</option>
                <option>UMI</option>
				<option>FPKM</option>
				<option>RPKM</option>
				<option>TPM</option>
              </select>
          </div>-->
		  <br>

		  
                </div>
            </div>
        </div>
    </div>
</div>

<div class="bs-example2">
    <div class="panel-group" id="accordion2">
        <div class="panel panel-default">
            <div class="panel-collapse-heading">
                <h4 class="panel-title">
                    <a data-toggle="collapse" data-parent="#accordion2" href="#collapseThree2">Biclustering options</a>
                </h4>
            </div>
            <div id="collapseThree2" class="panel-collapse collapse">
            <div class="panel-body">
          <h3 class="font-italic text-left">Discretization parameters</h3>
          <div class="form-group">
            <div class="row">
             
             <div class="col-sm-10">
               
               <div class="form-group">
						q <input name="c_arg" type="text" id="c_arg" value=0.06 size="5"><br />
               </div>

             </div>
            </div>
          </div>
		<h3 class="font-italic text-left">Biclustering parameters</h3>
          <div class="form-group">
            <div class="row">
             
             <div class="col-sm-10">
               
               <div class="form-group">
						c <input name="c_arg" type="text" id="c_arg" value=1 size="3">&nbsp;
						o <input name="o_arg" type="text" id="o_arg" value=5000 size="3">&nbsp;
						f <input name="f_from" type="text" id="f_from" value=0.5 size="3"><br />
						<!--
						k <input name="k_arg" type="text" id="k_arg" value=18 size="5"><br />
						f_to <input name="f_to" type="text" id="f_to" value=1.0  size="5"><br />
						f_by <input name="f_by" type="text" id="f_by" value=0.1 size="5"><br />
						--->
            
               </div>

             </div>
            </div>
          </div>
           <div class="form-group">
              
          </div>
                </div>
            </div>
        </div>
    </div>
</div>
        
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
<h3 class="font-italic text-left">Cell type resource for CTS-bicluster assignment</h3>
<div class="custom-control custom-radio custom-control-inline">
  <input type="radio" id="customRadioInline4" name="customRadioInline4" class="custom-control-input" checked="">
  <label class="custom-control-label" for="customRadioInline4">SC3</label>

</div>
<div class="custom-control custom-radio custom-control-inline">
  <input type="radio" id="customRadioInline5" name="customRadioInline4" class="custom-control-input">
  <label class="custom-control-label" for="customRadioInline5" onchange="document.getElementById('sendNewSms').disabled = !this.checked;">Your cell label</label>
  	<div class="form-check col-sm-7 ">
	  <label class="form-check-label" for="expfile">Upload your cell label file:</label><input type="file" class="form-control-file" id="sendNewSms" name="files" >
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
            <h3 class="font-italic text-left">Option 4</h3>
           <div class="form-group">
              
          </div>
		  <br>
                </div>
            </div>
        </div>
    </div>
</div>
                           
          
          
          <div id="emailfd" class="section" style="position:relative;top:10px;"> 
		  &nbsp;&nbsp;Optional: Please leave your email below; you will be notified by email when the job is done.<br/>
			<div class = "bootstrap-iso" style = "margin-top: 5px;">
				&nbsp;
				<strong>E-mail</strong>&nbsp;:<input name="emailf" type="text" id="emailf" size="60" style="position:relative;left:10px; width : 30%;" pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,3}$"/>       
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				</div>
          </div>
          
          <hr>
        <div class="form-group">
          <button type="submit" class="btn btn-primary" name="submit" value="submit">Submit</button>
		  <a class="btn btn-info" href="/iris3/results.php?jobid=20181004132017f" role="button">Example output</a>
        </div>
        
         <div class="form-group">
          <p id="words" class="hidden text-danger">Your job is running, don't close the browser tab, waiting time could vary from minutes to hour.</p>
        </div>
      
        
      </form>
      <!--</div>-->
      
           
    </main>





{{/block}}


