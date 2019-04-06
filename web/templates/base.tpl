<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <!--====== USEFULL META ======-->
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="integrated cell type specific Regulon inference from single-cell rna seq" />
    <meta name="keywords" content="scrnaseq, regulon, single cell rna seq,Cell-type-specific Regulon Single-cell RNA-Seq" />
    <title>IRIS3 - Integrated Cell-type-specific Regulon Inference Server from Single-cell RNA-Seq</title>
    <script src="assets/js/vendor/jquery-1.12.4.min.js"></script>
    <script src="assets/js/vendor/bootstrap.min.js"></script>
    <script src="assets/js/wow.min.js"></script>
    <script src="assets/js/jquery.ajaxchimp.js"></script>
    <script src="assets/js/jquery.sticky.js"></script>

    <!--<script>$(document).ready(function () {
  $('#motiftable').DataTable({
	"order": [[ 2, "asc" ]]
  });
  $('.dataTables_length').addClass('bs-select');
});  </script>-->
    <script src="assets/js/main.js"></script>
	<script type="text/javascript" charset="utf8" src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js"></script>

    <!--====== FAVICON ICON =======-->
	
    <link rel="shortcut icon" type="image/ico" href="assets/img/favicon.png" />
	<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.13.2/css/bootstrap-select.min.css">
    <!--====== STYLESHEETS ======-->
	<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.css">
	<link href="css/heroic-features.css" rel="stylesheet">
    <link href="assets/css/plugins.css" rel="stylesheet">
    <link href="assets/css/theme.css" rel="stylesheet">
    <link href="assets/css/icons.css" rel="stylesheet">

    <!--====== MAIN STYLESHEETS ======-->
    <link href="style.css" rel="stylesheet">
    <link href="assets/css/responsive.css" rel="stylesheet">
    <script src="assets/js/vendor/modernizr-2.8.3.min.js"></script>

    <!--[if lt IE 9]>
        <script src="//oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
        <script src="//oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
        <![endif]-->
	</head>
<!-- 
<div class="preeloader">
   <div class="preloader-spinner"></div>
    </div>
-->

    <!--SCROLL TO TOP-->
    <a href="#scroolup" class="scrolltotop"><i class="fa fa-long-arrow-up"></i></a>
        <div class="header-top-area" id="scroolup">
            <!--MAINMENU AREA-->
            <div class="mainmenu-area" id="mainmenu-area">
                <div class="mainmenu-area-bg"></div>
                <nav class="navbar">
                    <div class="container">
                        <div class="navbar-header">
                            <a class="navbar-brand" href="/iris3/index.php" style="color:white;font-size:24px">IRIS3</a>
                        </div>
                        <div id="main-nav" class="stellarnav">
                            <ul id="nav" class="nav navbar-nav pull-right">
                                <li><a href="/iris3/index.php">Home</a></li>
                                <li><a href="/iris3/submit.php">Submit</a></li>
                                <li><a href="/iris3/tutorial.php#1basics">Tutorial</a></li>
								<li><a href="/iris3/news.php#1version">What's new</a></li>
								<li><a href="https://groups.google.com/forum/#!forum/iris3-discussion-board">Forum</a></li>
								<li><a href="/iris3/more.php#4FAQ">More</a></li>
                            </ul>
                        </div>
                    </div>
                </nav>
            </div>
        </div>

      {{block name="head"}}
      
      {{/block}}


  
{{block name="main"}}

{{/block}}


    {{block name="foot"}}
    <footer class="footer-area sky-gray-bg">
        <div class="footer-bottom-area white">
            <div class="container">
                <div class="row">
                    <div class="col-md-12 col-lg-12 col-sm-12 col-xs-12">
                        <div class="footer-copyright text-center wow fadeIn">
                            <p class="m-0 text-center text">© <script>document.write(new Date().getFullYear());</script> <a href="https://www.sdstate.edu/bioinformatics-and-mathematical-biosciences-lab">BMBL</a> | <a href="mailto:bmbl.qinma@gmail.com" title="ma.1915@osu.edu">Contact us: ma.1915@osu.edu</a>  </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </footer>
	
	<!--<footer class="footer">
	<div class="footer-copyright text-center wow fadeIn">
                            <p class="m-0 text-center text">© <script>document.write(new Date().getFullYear());</script> <a href="https://www.sdstate.edu/bioinformatics-and-mathematical-biosciences-lab">BMBL</a> | <a href="mailto:bmbl.qinma@gmail.com" title="bmbl.qinma@gmail.com">Contact us: bmbl.qinma@gmail.com</a>  </p>
                        </div> </footer>-->
	
    {{/block}}
    
    <script type="text/javascript">

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