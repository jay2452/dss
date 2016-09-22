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


if !(Group.find_by_name "All members" )
  group = Group.create! name: "All members"


  User.all.each do |user|
    UserGroup.create! user_id: user.id, group_id: group.id
  end
end
