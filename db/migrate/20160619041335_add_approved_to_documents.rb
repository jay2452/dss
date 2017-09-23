class AddApprovedToDocuments < ActiveRecord::Migration[5.0]
  def change
    add_column :documents, :approved, :boolean, default: false
  end
end
