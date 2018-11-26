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


<table border="0" width="100%" bordercolor="000000">
<form action="{{$URL}}" method="POST" enctype="multipart/form-data" class="corner shadow" style="padding: 5px 30px; margin: 5px 0px;">
  <tr>
<br>
    <td align="middle">
<br>
	<div class = "frame" align="left" style="width:640px;height:30px;font-size:16px">
	<strong>1. Upload the gene expression file:(.csv)</strong> <br />
        <input name="expfile" type="file" id="expfile" size="70"><br />
		<input type="checkbox" name="radio" value="use_example">Or use the example file
		<br>
		<br>
		<strong>2. Select normalization method</strong> <br />
<input type="radio" name="radio" value="count">Read count
<input type="radio" name="radio" value="UMI">UMI
<input type="radio" name="radio" value="FPKM">FPKM
<input type="radio" name="radio" value="RPKM">RPKM
<input type="radio" name="radio" value="TPK">TPK
		<br>
		<br>
		<strong>3. Choose parameters</strong> <br />
		c <input name="c_arg" type="text" id="c_arg" value=1 size="5"><br />
		k <input name="k_arg" type="text" id="k_arg" value=18 size="5"><br />
		o <input name="o_arg" type="text" id="o_arg" value=100 size="5"><br />
		f_from <input name="f_from" type="text" id="f_from" value=0.5 size="5"><br />
		f_to <input name="f_to" type="text" id="f_to" value=1.0  size="5"><br />
		f_by <input name="f_by" type="text" id="f_by" value=0.1 size="5"><br />
		<br>
        <!-- <a href="http://bmbl.sdstate.edu/SeqTU_dev/data/exampleData/SRR3212906.fastq">right-click to  save/download an example of bam file</a><br /> -->
		
		<div class="submit">
          <input class="submit" type="submit" name="submit" value="submit" />
        </div>
		<br>
			<div class="container">
		© 2018 <a href="http://prod.sdstate.edu/agronomy-horticulture-and-plant-science/bioinformatics-and-mathematical-biosciences-lab">BMBL</a> |
		All rights reserved.
		<br><a href="mailto:qin.ma@sdstate.edu" title="qin.ma@sdstate.edu">Contact us: qin.ma@sdstate.edu</a>  
		</div>
		
	</div>
<!-- 

        <br></div>
	<div><br /></div>
	<div class = "frame" align="left" style="width:640px;height:30px;font-size:16px">
        <strong>3. Upload a reference genome sequence:(.fasta)</strong> <br />
        <input name="fnafile" type="file" id="fnafile" size="70"><br />
		<br /></div>
		<div class = "frame" align="left" style="width:640px;height:30px;font-size:16px">
		<br>
        <strong>4. Select GeneQC version(plant or animal)</strong> <br />
        
<input type="radio" name="radio" value="plant">For plant
<input type="radio" name="radio" value="animal">For animal
	<!-- <a href="./download/download_fna.php">left-click to download an example of fna file</a> 
        </div>
	<div><br /></div>
	<!-- <div class = "frame" align="left" style="width:640px;height:30px;font-size:15px"> -->
        <!-- <strong>4. Upload a ptt file:</strong> -->
        <!-- <input name="pttfile" type="file" id="pttfile" size="70"><br /> -->
	<!-- <a href="./download/download_ptt.php">left-click to download an example of ptt file</a> -->
        <!-- <br></div> -->
        <!-- <br> -->
	<!-- <div class = "frame" align="left" style="width:640px;height:30px;font-size:15px"> -->
	<!-- <strong>4. Enter your email address:</strong> -->
          <!-- <input id="id_email" name="id_email" type="text" style="width: 300px;" /> -->
	<!-- </div> -->

<br><br>

    </td>
  </tr>
</form>

</table>



{{/block}}


