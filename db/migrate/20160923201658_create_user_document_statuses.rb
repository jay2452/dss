class CreateUserDocumentStatuses < ActiveRecord::Migration[5.0]
  def change
    create_table :user_document_statuses do |t|
      t.references :user, index: true, foreign_key: true
      t.references :document, index: true, foreign_key: true
      t.integer :status, default: 0

      t.timestamps null: false
    end

    add_index :user_document_statuses, ["user_id", "document_id"], :unique => true
  end
end
