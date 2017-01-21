class UserNotifierMailer < ApplicationMailer

  # => send email to users if a an account is created

  def send_signup_email user
    @user = user
    mail to: @user.email, :subject => "Account created on GPIL Document Management System"
  end

  def account_create_notification user, password
    @user = user
    @pass = password
    mail to: @user.email, :subject => "Account created on GPIL Document Management System"
  end

  def account_update_notification user, password
    @user = user
    @pass = password
    mail to: @user.email, subject: "Password changed"
  end


  def added_to_project user, project
    @user = user
    @project = project
    mail to: @user.email, subject: "You have been added to project #{project.name}"
  end

  def removed_from_project user, project
    @user = user
    @project = project
  end

  def removed_from_role user, role
    @user = user
    @role = role
    mail to: @user.email, subject: "Removed from Role"
  end

  def added_to_role user, role
    @user = user
    @role = role
    mail to: @user.email, subject: "Added to Role"
  end

end
