class UserNotifierMailer < ApplicationMailer

  # => send email to users if a an account is created

  def send_signup_email user
    @user = user
    mail to: @user.email, :subject => "Account created on GPIL Document Management System"
  end
end
