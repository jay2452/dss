class AddRoleToLogs < ActiveRecord::Migration[5.0]
  def change
    add_reference :logs, :role, foreign_key: true
  end
end
