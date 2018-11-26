<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=UA-114510016-1"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'UA-114510016-1');
  
</script>
		<title>IRIS3</title>
		<meta name="keywords" content="GeneQC">
		<meta name="description" content="GeneQC: Gene expression level Quality Control">
		<meta name="viewport" content="initial-scale=1.0,user-scalable=no">
		<link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
		<link href="css/heroic-features.css" rel="stylesheet">
		<link rel="stylesheet" href="static/css/jquery.datatable/jquery.dataTables.css" />
		<link rel="stylesheet" href="static/css/jquery.datatable/jquery.dataTables_themeroller.css" />
		<link rel="stylesheet" href="static/css/jquery.datatable/jquery.dataTables.min.css" />
	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

	
    <script type="text/javascript" src="static/js/jquery.js"></script>
    <script type="text/javascript" src="static/js/jquery-ui.js"></script>
    <script type="text/javascript" src="static/js/jquery.corner.js"></script>
    <script type="text/javascript" src="static/js/jquery.qtip.js"></script>
    <script type="text/javascript" src="static/js/jquery.dataTables.js"></script>
    <script type="text/javascript" src="static/js/jquery.dataTables.FixedHeader.js"></script>
    <script type="text/javascript" src="static/js/jquery.dataTables.ColVis.js"></script>
	<script src="//code.jquery.com/jquery-1.11.1.min.js"></script>
		

<script type="text/javascript">
    jQuery(function ($) {
        $("#files").shieldUpload();
    });
</script>
<script type="text/javascript">
  var _paq = _paq || [];
  _paq.push(['trackPageView']);
  _paq.push(['enableLinkTracking']);
  (function() {
    var u="//bmbl.sdstate.edu/DMINDA2/piwik/";
    _paq.push(['setTrackerUrl', u+'piwik.php']);
    _paq.push(['setSiteId', '2']);
    var d=document, g=d.createElement('script'), s=d.getElementsByTagName('script')[0];
    g.type='text/javascript'; g.async=true; g.defer=true; g.src=u+'piwik.js'; s.parentNode.insertBefore(g,s);
  })();
</script>

	</head>

  </head>
<header id="header" class="clearfix">
    <div class="container">
        <div class="col-group">
            <div class="site-name ">
                
            </div>
        </div>
    </div>


</header>
  <body>
    <div class="corner" id="pane">

      {{block name="head"}}
      
      {{/block}}
      
      <div id="main">
	  	    <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
      <div class="container">
        <a class="navbar-brand" href="/iris3/index.php">IRIS3</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarResponsive">
          <ul class="navbar-nav ml-auto">
            <li class="nav-item">
              <a class="nav-link" href="/iris3/index.php">Home
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="/iris3/submit.php">Submit</a>
            </li>
            <!--<li class="nav-item">
              <a class="nav-link" href="/iris3/intro.php">Introduction</a>
            </li>-->
            <li class="nav-item">
              <a class="nav-link" href="/iris3/tutorial.php">Tutorial</a>
            </li>
          </ul>
        </div>
      </div>
    </nav>
      {{block name="main"}}
      {{/block}}
      </div>

    </div>

    {{block name="foot"}}
    <footer class="footer">
		<div class="container">
		<p class="m-0 text-center text">© 2018 <a href="https://www.sdstate.edu/bioinformatics-and-mathematical-biosciences-lab">BMBL</a> |
		All rights reserved.</p><p class="m-0 text-center text"><a href="mailto:qin.ma@sdstate.edu" title="qin.ma@sdstate.edu">Contact us: qin.ma@sdstate.edu</a>  </p>
		</div>
      <!-- /.container -->
    </footer>
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
