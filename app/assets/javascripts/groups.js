function validateProject(project) {
  $("#" + project).validate({
    onkeyup: false,
    onfocusout: function (element, event) {
      this.element(element);
    },
    invalidHandler: function () {
      $(this).find(":input.error:first").focus();
    },
    rules: {
      "group[name]": {
        required: true
      }
    },
    messages: {
      "group[name]": {
        required: "Please enter the project name"
      }
    },
    submitHandler: function (form) {
      form.submit();
    }
  });
}
