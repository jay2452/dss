function validateUser(user) {
  $("#" + user).validate({
    onkeyup: false,
    onfocusout: function (element, event) {
      this.element(element);
    },
    invalidHandler: function () {
      $(this).find(":input.error:first").focus();
    },
    rules: {
      "user[username]": {
        required: true,
      },
      "user[email]": {
        required: true,
      },
      "user[password]": {
        required: true,
      },
      "user[designation]": {
        required: true,
      },
      "user[mobile]": {
        required: true,
      }
    },
    messages: {
      "user[username]": {
        required: "Please enter a user name and it must be unique",
      },
      "user[email]": {
        required: "Please enter a valid email id"
      },
      "user[password]": {
        required: "Please enter a password and password must be of mimimum 8 characters"
      },
      "user[designation]": {
        required: "Please enter the designation of employee"
      },
      "user[mobile]": {
        required: "Please enter a valid 10 digit mobile number"
      }
    },
    submitHandler: function (form) {
      form.submit();
    }
  });
}

function updateUser(user) {
  $("#" + user).validate({
    onkeyup: false,
    onfocusout: function (element, event) {
      this.element(element);
    },
    invalidHandler: function () {
      $(this).find(":input.error:first").focus();
    },
    rules: {
      "user[current_password]": {
        required: true,
      },
      "user[password]": {
        required: true,
      },
      "user[password_confirmation]": {
        required: true,
      }
    },
    messages: {
      "user[current_password]": {
        required: "Please enter the current password",
      },
      "user[password]": {
        required: "Please enter the new password and it must be of mimimum 8 characters"
      },
      "user[password_confirmation]": {
        required: "Please re-enter the new password"
      }
    },
    submitHandler: function (form) {
      form.submit();
    }
  });
}
