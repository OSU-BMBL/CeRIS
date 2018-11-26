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


  
    <!--[if lt IE 8]>
        <p class="browserupgrade">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> to improve your experience.</p>
    <![endif]-->

    <!--- PRELOADER -->
    <div class="preeloader">
        <div class="preloader-spinner"></div>
    </div>

    <!--SCROLL TO TOP-->
    <a href="#scroolup" class="scrolltotop"><i class="fa fa-long-arrow-up"></i></a>
        <div class="header-top-area" id="scroolup">
            <!--MAINMENU AREA-->
            <div class="mainmenu-area" id="mainmenu-area">
                <div class="mainmenu-area-bg"></div>
                <nav class="navbar">
                    <div class="container">
                        <div class="navbar-header">
                            <a class="navbar-brand" href="/iris3/index.php" style="color:white">IRIS3</a></a>
                        </div>
                        <div id="main-nav" class="stellarnav">
                            <ul id="nav" class="nav navbar-nav pull-right">
                                <li class="active"><a href="/iris3/index.php">Home</a></li>
                                <li><a href="/iris3/submit.php">Submit</a></li>
                                <li><a href="/iris3/tutorial.php">Tutorial</a></li>
								<li><a href="/iris3/news.php">News</a></li>
								<li><a href="/iris3/news.php">Forum</a></li>
								<li><a href="/iris3/contact.php">Contact</a></li>
                            </ul>
                        </div>
                    </div>
                </nav>
            </div>
        </div>
    <!--START TOP AREA-->
    <header class="top-area" id="home">


        <!--WELCOME SLIDER AREA-->
        <div class="welcome-slider-area white font16">
            <div class="welcome-single-slide">
                <div class="slide-bg-one slide-bg-overlay"></div>
                <div class="welcome-area">
                    <div class="container">
                        <div class="row flex-v-center">
                            <div class="col-md-8 col-lg-7 col-sm-12 col-xs-12">
                                <div class="welcome-text">
                                    <h1>IRIS3</h1>
                                    <p>IRIS3 description</p>
                                    <div class="home-button">
                                        <form action="#">
                                            <input type="search" name="search" id="search" placeholder="Search Courses">
                                            <button type="submit"><i class="fa fa-search"></i></button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
	<section class="features-top-area" id="features">
        <div class="container">
            <div class="row promo-content">
                <div class="col-md-4 col-lg-4 col-sm-6 col-xs-12">
                    <div class="text-icon-box mb20 xs-mb0 wow fadeInUp padding30" data-wow-delay="0.1s">
                        <!--<div class="box-icon features-box-icon">
                            <i class="fa fa-graduation-cap"></i>
                        </div>-->
                        <h3 class="box-title">Tutorial</h3>
                        <p>New to IRIS3? Our detailed tutorial will guide you through the process of using IRIS3.</p><br>
						<p><a class="enroll-button" href="/iris3/tutorial.php" role="button">Learn More</a></p>
                    </div>
                </div>
                <div class="col-md-4 col-lg-4 col-sm-6 col-xs-12">
                    <div class="text-icon-box relative mb20 xs-mb0  wow fadeInUp padding30" data-wow-delay="0.2s">
                        <!--<div class="box-icon features-box-icon">
                            <i class="icofont icofont-business-man-alt-1"></i>
                        </div>-->
                        <h3 class="box-title">New Job</h3>
                                   <p>Submit a new a job using your new data.</p><br>
            <p><a class="enroll-button" href="/iris3/submit.php" role="button">Start a new job </a></p>
                    </div>
                </div>
                <div class="col-md-4 col-lg-4 col-sm-6 col-xs-12">
                    <div class="text-icon-box relative mb20 xs-mb0 wow fadeInUp padding30" data-wow-delay="0.3s">
                        <!--<div class="box-icon features-box-icon">
                            <i class="fa fa-rocket"></i>
                        </div>-->
                        <h3 class="box-title">News</h3>
                                    <p>Posted: 10/17/2018</p>
            <p>This server has been upgraded to version 1.0</a></p>
                    </div>
                </div>
                <div class="col-md-4 col-lg-4 col-sm-6 col-xs-12">
						
                </div>
            </div>
        </div>
    </section>
            </div>
        </div>
        <!--WELCOME SLIDER AREA END-->

    </header>
    <!--END TOP AREA-->

    <!--FEATURES TOP AREA-->
    

    <!--FOOER AREA END-->









{{/block}}


