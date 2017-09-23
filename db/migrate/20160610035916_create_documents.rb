class CreateDocuments < ActiveRecord::Migration[5.0]
  def change
    create_table :documents do |t|
      t.string :name
      t.integer :document_category_id

      t.timestamps null: false
    end
  end
end
