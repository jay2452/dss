module DocumentsHelper

  def check_status? document
    d = DocumentGroup.where("document_id = ? AND group_id = ?", document.id, document.group_id).first
    if d
      return true
    else
      return false
    end
  end

end
