
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
