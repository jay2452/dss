class AddDisabledToGroups < ActiveRecord::Migration[5.0]
  def change
    add_column :groups, :disabled, :boolean, default: false
  end
end
