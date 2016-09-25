class AddGroupIdToDocuments < ActiveRecord::Migration
  def change
    add_reference :documents, :group, index: true, foreign_key: true
  end
end
