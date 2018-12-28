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

    <header class="top-area" id="home" >


        <!--WELCOME SLIDER AREA-->
        <div class="welcome-slider-area white font16">
            <div class="welcome-single-slide">
                <div class="slide-bg-one slide-bg-overlay"></div>
                <div class="welcome-area">
                    <div class="container">
                        <div class="row flex-v-center">
                            <div class="col-md-7 col-lg-7 col-sm-7 col-xs-7">
                                <div class="welcome-text">
                                    <h1>IRIS3</h1>
                                    <p>Integrated Cell-type-specific Regulon Inference from Single-cell RNA-Seq</p>
                                    <div class="home-button">
                                        <form method="POST" action="{{$URL}}" encType="multipart/form-data" id="needs-validation">
                                            <input type="text" name="jobid" id="jobid" placeholder="Search your job ID">
                                            <button type="submit" name="submit" value="submit"><i class="fa fa-search"></i></button>
                                        </form>
                                    </div>
                                </div>
                            </div>
							 <div class="col-md-5 col-lg-5 col-sm-5 col-xs-5">
                                <div class="welcome-text">
                                 <a href="assets/img/iris3_pipeline.png" target="_blank"><img src="assets/img/iris3_pipeline.webp" style="height:500px;margin:auto;display:block"></a>
                                               
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
                        <h3 class="box-title">What's new</h3>
                                    <p>Posted: 12/23/2018</p>
						<p>Page Layout, link and button color improvements.</a></p>
            <p><a class="enroll-button" href="/iris3/news.php" role="button">More changes</a></p>
                    </div>
                </div>
                <div class="col-md-4 col-lg-4 col-sm-6 col-xs-12">
						
                </div>
            </div>
			
			<div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">Modal title</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        ...
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
        <button type="button" class="btn btn-primary">Save changes</button>
      </div>
    </div>
  </div>
</div>
        </div>
    </section>
            </div>
        </div>
        <!--WELCOME SLIDER AREA END-->
<div class="push"></div>
    </header>








{{/block}}


