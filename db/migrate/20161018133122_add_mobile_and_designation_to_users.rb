class AddMobileAndDesignationToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :mobile, :bigint
    add_column :users, :designation, :string
    add_column :users, :username, :string, unique: true

    add_index :users, :username
  end
end
