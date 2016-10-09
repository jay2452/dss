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
//= require jquery_ujs
//= require bootstrap-sprockets
//= require turbolinks
//= require_tree .

$(document).ready(function() {
  if ($('.pagination').length) {
    $(window).scroll(function() {
      var url = $('.pagination .next_page').attr('href');
      if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 50) {
        $('.pagination').html('<div align="center"><img src="/assets/ajax-loader.gif" alt="Loading..." title="Loading..." /> </div>')
        return $.getScript(url);
      }
    });
    return $(window).scroll();
  }
});


function validateDocument(docID) {
  $("#" + docID).validate({
    onkeyup: false,
    onfocusout: function (element, event) {
      this.element(element);
    },
    invalidHandler: function () {
      $(this).find(":input.error:first").focus();
    },
    rules: {
      "document[name]": {
        required: true,
      },
      "document[group_id]": {
        required: true,
      },
      "document[file]": {
        required: true,
      }
    },
    messages: {
      "document[name]": {
        required: "Please fill document name/title",
      },
      "document[group_id]": {
        required: "Please select a Project"
      },
      "document[file]": {
        required: "Please upload a file"
      }
    },
    submitHandler: function (form) {
      form.submit();
    }
  });
}
