class AddIsActiveToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :is_active, :boolean, default: true

    User.all.each do |user|
      if !user.active_for_authentication?
        user.update_attribute(:is_active, false)
      end
    end

  end
end
