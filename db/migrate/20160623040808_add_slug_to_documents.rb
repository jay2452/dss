class AddSlugToDocuments < ActiveRecord::Migration[5.0]
  def change
    add_column :documents, :slug, :string
    add_index :documents, :slug
  end
end
