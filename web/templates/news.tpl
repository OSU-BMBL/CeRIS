{{extends file="base.tpl"}}

{{block name="extra_style"}}
  form div.fieldWrapper label { min-width: 5%; }
{{/block}}

{{block name="extra_js"}}

<script type="text/javascript">
  
</script>
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
					&nbsp;&nbsp;&nbsp;11/4/2018<br/><br/>
					<p>
						We update this server regularly so we can make it better for you. This version includes several bug fixes and performance improvements.
					</p>
					<hr/>
					
					
					&nbsp;&nbsp;&nbsp;10/17/2018<br/><br/>
					<p>
						This server has been upgraded to version 1.0
					</p>
					<hr/>
				</div>
			</div>
			<hr>

            
        

        

     

    </main>




{{/block}}


