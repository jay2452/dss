# Preview all emails at http://localhost:3000/rails/mailers/documents_notifier_mailer
class DocumentsNotifierMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/documents_notifier_mailer/new_doc_notification
  def new_doc_notification
    DocumentsNotifierMailer.new_doc_notification
  end

end
