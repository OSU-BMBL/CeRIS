/*-----------------------------------------------------------------------------------*/
/*	BACKGROUND IMAGE
/*-----------------------------------------------------------------------------------*/

$(function() {

	// Options for SuperBGImage
	$.fn.superbgimage.options = {
		randomtransition: 2, // 0-none, 1-use random transition (0-7)
		z_index: -1, // z-index for the container
		slideshow: 1, // 0-none, 1-autostart slideshow
		slide_interval: 4000, // interval for the slideshow
		randomimage: 1, // 0-none, 1-random image
		speed: 'slow' // animation speed
	};

	// initialize SuperBGImage
	$('#thumbs').superbgimage().hide();

});
/*-----------------------------------------------------------------------------------*/
/*	MENU
/*-----------------------------------------------------------------------------------*/

ddsmoothmenu.init({
	mainmenuid: "menu",
	orientation: 'h',
	classname: 'menu',
	contentsource: "markup"
})


/*-----------------------------------------------------------------------------------*/
/*	IMAGE HOVER
/*-----------------------------------------------------------------------------------*/
$(function() {
$('.flickr img, .blog a img, #.container a img, .content a img').css("opacity","1.0");	
$('.flickr img, .blog a img, #container a img, .content a img').hover(function () {										  
$(this).stop().animate({ opacity: 0.75 }, "fast"); },	
function () {			
$(this).stop().animate({ opacity: 1.0 }, "fast");
});
});


/*-----------------------------------------------------------------------------------*/
/*	OPACITY
/*-----------------------------------------------------------------------------------*/

$('.opacity').transify({opacityOrig:.90, percentHeight:'100%'});

/*-----------------------------------------------------------------------------------*/
/*	PRETTYPHOTO
/*-----------------------------------------------------------------------------------*/

$(document).ready(function(){
			$("a[rel^='prettyPhoto']").prettyPhoto({autoplay_slideshow: false, overlay_gallery: false, social_tools:false, deeplinking: false, theme:'pp_default', slideshow:5000});
		});

/*-----------------------------------------------------------------------------------*/
/*	TOGGLE
/*-----------------------------------------------------------------------------------*/
$(document).ready(function(){
//Hide the tooglebox when page load
$(".togglebox").hide();
//slide up and down when click over heading 2
$("h2").click(function(){
// slide toggle effect set to slow you can set it to fast too.
$(this).toggleClass("active").next(".togglebox").slideToggle("slow");
return true;
});
});

/*-----------------------------------------------------------------------------------*/
/*	TABS
/*-----------------------------------------------------------------------------------*/
$(document).ready(function() {
	//Default Action
	$(".tab_content").hide(); //Hide all content
	$("ul.tabs li:first").addClass("active").show(); //Activate first tab
	$(".tab_content:first").show(); //Show first tab content
	
	//On Click Event
	$("ul.tabs li").click(function() {
		$("ul.tabs li").removeClass("active"); //Remove any "active" class
		$(this).addClass("active"); //Add "active" class to selected tab
		$(".tab_content").hide(); //Hide all tab content
		var activeTab = $(this).find("a").attr("href"); //Find the rel attribute value to identify the active tab + content
		$(activeTab).fadeIn(); //Fade in the active content
		return false;
	});

});

/*-----------------------------------------------------------------------------------*/
/*	IMAGE HOVER
/*-----------------------------------------------------------------------------------*/
 $(document).ready(function() {
        $('.box, .carousel ul li').mouseenter(function(e) {

            $(this).children('a').children('span').fadeIn(200);
        }).mouseleave(function(e) {

            $(this).children('a').children('span').fadeOut(200);
        });
    });
