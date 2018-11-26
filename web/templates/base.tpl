<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <!--====== USEFULL META ======-->
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="" />
    <meta name="keywords" content="" />

    <!--====== TITLE TAG ======-->
    <title>IRIS3</title>
	<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.css">
	<script type="text/javascript" charset="utf8" src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.js"></script>

    <!--====== FAVICON ICON =======-->
    <link rel="shortcut icon" type="image/ico" href="assest/img/favicon.png" />

    <!--====== STYLESHEETS ======-->
		<link href="css/heroic-features.css" rel="stylesheet">
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
		

    <link href="assest/css/plugins.css" rel="stylesheet">
    <link href="assest/css/theme.css" rel="stylesheet">
    <link href="assest/css/icons.css" rel="stylesheet">

    <!--====== MAIN STYLESHEETS ======-->
    <link href="style.css" rel="stylesheet">
    <link href="assest/css/responsive.css" rel="stylesheet">

    <script src="assest/js/vendor/modernizr-2.8.3.min.js"></script>
    <!--[if lt IE 9]>
        <script src="//oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
        <script src="//oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
        <![endif]-->
		
	</head>

  </head>

  <body data-spy="scroll" data-target=".mainmenu-area" data-offset="90">
	
 
      {{block name="head"}}
      
      {{/block}}


  
      {{block name="main"}}
      {{/block}}
      </div>

    </div>

    {{block name="foot"}}
    <footer class="footer-area sky-gray-bg relative">
        <div class="footer-bottom-area white">
            <div class="container">
                <div class="row">
                    <div class="col-md-12 col-lg-12 col-sm-12 col-xs-12">
                        <div class="footer-copyright text-center wow fadeIn">
                            <p><!-- Link back to Colorlib can't be removed. Template is licensed under CC BY 3.0. --><p class="m-0 text-center text">© <script>document.write(new Date().getFullYear());</script> <a href="https://www.sdstate.edu/bioinformatics-and-mathematical-biosciences-lab">BMBL</a> |
 All rights reserved | This template is made with <i class="fa fa-heart-o" aria-hidden="true"></i> by <a href="https://colorlib.com" target="_blank">Colorlib</a>
<!-- Link back to Colorlib can't be removed. Template is licensed under CC BY 3.0. --></p><p class="m-0 text-center text"><a href="mailto:qin.ma@sdstate.edu" title="qin.ma@sdstate.edu">Contact us: qin.ma@sdstate.edu</a>  </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </footer>
    {{/block}}
    
    <script type="text/javascript">
      $(document).ready(function() {
    $('#example').DataTable( {
        "order": [[ 3, "desc" ]]
    } );
} );
	  var _gaq = _gaq || [];
      _gaq.push(['_setAccount', 'UA-8700754-6']);
      _gaq.push(['_trackPageview']);
    
      (function() {
        var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
        ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
      })();
    </script>
  </body>
</html>
	<!--====== SCRIPTS JS ======-->
    <script src="assest/js/vendor/jquery-1.12.4.min.js"></script>
    <script src="assest/js/vendor/bootstrap.min.js"></script>

    <!--====== PLUGINS JS ======-->
    <script src="assest/js/vendor/jquery.easing.1.3.js"></script>
    <script src="assest/js/vendor/jquery-migrate-1.2.1.min.js"></script>
    <script src="assest/js/vendor/jquery.appear.js"></script>
    <script src="assest/js/owl.carousel.min.js"></script>
    <script src="assest/js/stellar.js"></script>
    <script src="assest/js/waypoints.min.js"></script>
    <script src="assest/js/jquery.counterup.min.js"></script>
    <script src="assest/js/wow.min.js"></script>
    <script src="assest/js/jquery-modal-video.min.js"></script>
    <script src="assest/js/stellarnav.min.js"></script>
    <script src="assest/js/placeholdem.min.js"></script>
    <script src="assest/js/contact-form.js"></script>
    <script src="assest/js/jquery.ajaxchimp.js"></script>
    <script src="assest/js/jquery.sticky.js"></script>

    <!--===== ACTIVE JS=====-->
    <script src="assest/js/main.js"></script>
	
	<script>   $(document).ready(function () {
  $('#motiftable').DataTable({
	"order": [[ 2, "asc" ]]
  });
  $('.dataTables_length').addClass('bs-select');
});</script>