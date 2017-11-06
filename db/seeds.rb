# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Role.destroy_all

Role.create! name: "admin"
Role.create! name: "viewUser"
Role.create! name: "uploadUser"
Role.create! name: "approveUser"
Role.create! name: "superAdmin"



User.destroy_all
a = User.create! email: "admin@admin.com", password: "123456789", mobile: "9040434782"
a.add_role :admin

b = User.create! email: "superadmin@admin.com", password: "123456789", mobile: "7809424573"
b.add_role :superAdmin



# if !(Group.find_by_name "Project-1" )
#   group = Group.create! name: "Project-1"
#
#
#   User.all.each do |user|
#     UserGroup.create! user_id: user.id, group_id: group.id
#   end
# end
