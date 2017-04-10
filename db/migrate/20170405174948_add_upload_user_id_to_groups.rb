class AddUploadUserIdToGroups < ActiveRecord::Migration[5.0]
  def change
    add_column :groups, :upload_user_id, :integer, default: -1

    add_index :groups, :upload_user_id
  end
end
