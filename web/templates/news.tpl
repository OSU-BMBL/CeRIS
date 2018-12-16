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
    <main role="main">

      <!-- Main jumbotron for a primary marketing message or call to action -->
<main role="main" class="container">


            <hr>
            <h2 class="text-center">IRIS3 news</h2>
            <div class = "bootstrap-iso">
					<br/>
					<h3>[0.0.4] - 12/13/2018<br/><br/></h3>
					<h4>Added</h4>
					<a href="https://www.dropzonejs.com/" target="_blank"> DragZone</a>, a drag and drop widget for uploading expression data.
					<h4>Changed</h4>
					<p>
					  Advanced options layout on <a href="http://bmbl.sdstate.edu/iris3/submit.php" target="_blank"> Submit</a> page.
					</p>
					<hr/>
					<h3>[0.0.3] - 12/09/2018<br/><br/></h3>
					<h4>Added</h4>
					<p>
						<a href="http://meme-suite.org/tools/meme" target="_blank"> MEME</a> for an optinal back-end DNA motif identification program.
					</p>
					<hr/>
					<h3>[0.0.2] - 11/04/2018<br/><br/></h3>
					<h4>Added</h4>
					<p>
						<a href="https://clustergrammer.readthedocs.io/" target="_blank"> Clustergrammer</a>, a interactive web-based tool for visualizing heatmaps for result visualization.
					</p>
					<p>
						<a href="http://bmbl.sdstate.edu/iris3/assest/img/iris3_pipeline.png" target="_blank"> Pipeline overview</a> on homepage.
					</p>
					<p>
						<a href="http://bmbl.sdstate.edu/iris3/tutorial.php" target="_blank"> Tutorial</a>,<a href="http://bmbl.sdstate.edu/iris3/faq.php" target="_blank"> FAQ</a>, <a href="http://bmbl.sdstate.edu/iris3/contact.php" target="_blank">Contact</a>, <a href="https://groups.google.com/forum/#!forum/iris3-discussion-board" target="_blank">Forum</a> sections.
					</p>
					<hr/>
					
					<h3>[0.0.1] - 10/17/2018<br/><br/></h3>
					<h4>Added</h4>
					<p>
						The website is now hosting under  <a href="https://www.sdstate.edu/agronomy-horticulture-plant-science/bioinformatics-and-mathematical-biosciences-lab" target="_blank">bmbl.sdstate.edu</a> domain.
					</p>
					<hr/>
				</div>
			</div>

            
        

        

     

    </main>




{{/block}}


