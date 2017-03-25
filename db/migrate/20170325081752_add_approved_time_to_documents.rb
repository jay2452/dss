class AddApprovedTimeToDocuments < ActiveRecord::Migration[5.0]
  def change
    add_column :documents, :approved_at, :datetime
  end
end
