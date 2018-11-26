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
      <div class="jumbotron">
        <div class="container">
				
          <h1 class="display-3">IRIS3</h1>
          <p>IRIS3 brief introduction</p>
        </div>
		<!-- Search form -->

      </div>

      <div class="container">
        <!-- Example row of columns -->
        <div class="row">
          <div class="col-md-4">
            <h2>Tutorial</h2>
            <p>New to IRIS3? Our detailed tutorial will guide you through the process of using IRIS3.</p>
            <p><a class="btn btn-secondary" href="/iris3/tutorial.php" role="button">Learn more</a></p>
          </div>
          <div class="col-md-4">
            <h2>New Job</h2>
            <p>Submit a new a job of your own dataset or try our web server by using our sample dataset.</p>
            <p><a class="btn btn-secondary" href="/iris3/submit.php" role="button">Start a new job </a></p>
			<!--<div class="mb-4">
  
  <p><input class="form-control" type="text" placeholder="Enter your job id" aria-label="Search"><a class="btn btn-secondary" href="/iris3/submit.php" role="button">Check your job</a></p>
</div>-->
          </div>
          <div class="col-md-4">
            <h2>News</h2>
            <p>Posted: 10/17/2018</p>
            <p>This server has been upgraded to version 1.0</a></p>
          </div>
        </div>

        <hr>

      </div> <!-- /container -->

    </main>





{{/block}}


