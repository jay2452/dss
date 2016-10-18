class RemoveMobileFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :mobile, :integer
  end
end
