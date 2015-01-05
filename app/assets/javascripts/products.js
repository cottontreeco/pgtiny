//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery(document).ready(function () {
  var $container = $('#product-container');
  $container.masonry({
      itemSelector:'.box',
      isFitWidth:true,
      isAnimated:true,
      animationOptions:{
        duration:750,
        easing:'linear',
        queue:false
      }
    }).imagesLoaded(function () {
      $container.masonry('reload');
    });
})
