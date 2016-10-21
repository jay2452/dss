class DocumentsNotifierMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.documents_notifier_mailer.new_doc_notification.subject
  #
  def new_doc_notification doc, users
    @document = doc
    mail to: users, subject: "New Document uploaded"
  end
end
