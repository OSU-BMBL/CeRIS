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

      <div class="container">
        <!-- Example row of columns -->
		<hr>
		<div>
          <h2 class="text-center">IRIS3 Tutorial</h2>
		  <a target="_blank"  href="https://help.plot.ly/tutorials/#statistical">Plot.ly charts example</a><br>
		  <a target="_blank"  href="http://circos.ca/guide/tables/">Circos table example</a><br>
		  
		  <a target="_blank"  href="http://circos.ca/intro/published_images/">Published Circos images</a><br>
		  <a target="_blank"  href="https://www.semanticscholar.org/paper/MetViz-%3A-an-online-visualization-tool-for-regulons-Vasanth/42dbf425f22201c72c9544d09dab45c4e68c5bac/figure/4">MetViz : an online visualization tool for regulons , genes and gene ontology</a><br>
		  <a target="_blank"  href="http://www.prodonet.tu-bs.de/">ProdoNet: identification and visualization of prokaryotic gene regulatory and metabolic networks</a><br>
        </div>


        <hr>

      </div> <!--<img src="http://circos.ca/guide/tables/img/guide-table.png"> /container -->

    </main>



{{/block}}


