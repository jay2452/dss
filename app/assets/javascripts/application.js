// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require selectize
//= require bootstrap-sprockets
//= require turbolinks
//= require_tree .

$(document).ready(function() {
  if ($('.pagination').length) {
    $(window).scroll(function() {
      var url = $('.pagination .next_page').attr('href');
      if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 50) {
        $('.pagination').html('<div id="gif-loader" align="center"><img src="/assets/ajax-loader.gif" alt="Loading..." title="Loading..." /> </div>')
        return $.getScript(url);
      }
    });
    return $(window).scroll();
  }

  $("#menu-toggle").click(function(e) {
      e.preventDefault();
      $("#wrapper").toggleClass("toggled");
  });


    // $('.chosen-select').chosen({
    //   allow_single_deselect: true,
    //   no_results_text: 'No results matched',
    //   width: '100%;'
    // });


});

setTimeout(function(){
  $('#notice_wrapper').fadeOut("slow", function() {
    $(this).remove();
  })
}, 3000);
