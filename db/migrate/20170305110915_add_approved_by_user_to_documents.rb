class AddApprovedByUserToDocuments < ActiveRecord::Migration[5.0]
  def change
    add_column :documents, :approved_by_user, :integer, default: -1
  end
end
