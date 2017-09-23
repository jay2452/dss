class AddGroupIdToDocuments < ActiveRecord::Migration[5.0]
  def change
    add_reference :documents, :group, index: true, foreign_key: true
  end
end
