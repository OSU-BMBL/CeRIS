{{extends file="base.tpl"}}

{{block name="extra_style"}}
  form div.fieldWrapper label { min-width: 5%; }
{{/block}}

{{block name="extra_js"}}
{{/block}}
{{block name="main"}}


  
    <!--[if lt IE 8]>
        <p class="browserupgrade">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> to improve your experience.</p>
    <![endif]-->
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
                                    <p>Integrated Cell-type-specific Regulon Inference from Single-cell RNA-Seq</p>
                                    <div class="home-button">
                                        <form action="#">
                                            <input type="search" name="search" id="search" placeholder="Search your job ID">
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
                            <p>Submit a new job using your new data.</p><br>
            <p><a class="enroll-button" href="/iris3/submit.php" role="button">Start a new job </a></p>
                    </div>
                </div>
                <div class="col-md-4 col-lg-4 col-sm-6 col-xs-12">
                    <div class="text-icon-box relative mb20 xs-mb0 wow fadeInUp padding30" data-wow-delay="0.3s">
                        <!--<div class="box-icon features-box-icon">
                            <i class="fa fa-rocket"></i>
                        </div>-->
                        <h3 class="box-title">News</h3>
                                    <p>Posted: 11/04/2018</p>
            <p>We update this server regularly so we can make it better for you. This version includes several bug fixes and performance improvements.</a></p>
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


