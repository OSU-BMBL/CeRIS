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

<!-- Piwik -->
<!-- Piwik -->
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
            <div id="particles-js">
                <script type="text/javascript">
                    particlesJS('particles-js', particlejson);
                </script>
            </div>
            <div class="site-name ">
                
            </div>
        </div>
    </div>
</header>
  <body>
    <div class="shadow corner" id="pane">

      {{block name="head"}}
      
      {{/block}}
      
      <div id="main" style="min-height: 320px;">
      {{block name="main"}}
      {{/block}}
      </div>

    </div>

    {{block name="foot"}}

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
