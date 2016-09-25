module WelcomeHelper
  def doc_status(document, user)
    a = document.user_document_statuses.where("user_id = ?", user.id).first
    if a != nil
      return a.status
    else
      return 0
    end
  end
end
