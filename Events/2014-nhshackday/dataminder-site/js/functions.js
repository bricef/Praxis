$(function() {
	$(document).on('focusin', '.field, textarea', function() {
		if(this.title==this.value) {
			this.value = '';
		}
	}).on('focusout', '.field, textarea', function(){
		if(this.value=='') {
			this.value = this.title;
		}
	});
});

$(window).load(function() {
	$('.flexslider').flexslider({
		animation: "slide",
		controlsContainer: ".slider-holder",
		slideshowSpeed: 9000,
		directionNav: true,
		controlNav: false,
		animationDuration: 1900
	});
});