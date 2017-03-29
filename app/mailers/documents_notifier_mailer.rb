class DocumentsNotifierMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.documents_notifier_mailer.new_doc_notification.subject
  #
  def new_doc_notification doc, user
    @document = doc
    mail to: user, subject: "New Document uploaded"
  end

  def notify_approver doc, user
    @document = doc
    mail to: user, subject: "New Document uploaded"
  end

  def notify_uploader doc, user
    @document = doc
    mail to: user, subject: "Document approved !"
  end


  def notify_new_owner doc, user
    @document = doc
    mail to: user, subject: "Document Assigned!"
  end

  def notify_previous_owner doc, user
    @document = doc
    mail to: user, subject: "Ownership to document changed"
  end

end
