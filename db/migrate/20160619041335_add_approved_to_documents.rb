class AddApprovedToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :approved, :boolean, default: false
  end
end
