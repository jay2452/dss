class AddUserIdToDocumentGroups < ActiveRecord::Migration[5.0]
  def change
    add_reference :document_groups, :user, foreign_key: true
  end
end
