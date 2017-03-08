class AddIsApproverToUserGroups < ActiveRecord::Migration[5.0]
  def change
    add_column :user_groups, :is_approver, :boolean, default: false
  end
end
