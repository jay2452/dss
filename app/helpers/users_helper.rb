module UsersHelper

  def fetch_roles(id)
    user = User.find(id)
    user_role = user.roles.map(&:name)
  end
    # 
    #
    # def remove_user_role(user_id, role_id)
    #   # ac = UsersRole.where("user_id = ? AND role_id = ?", user_id, role_id ).first
    #   user = User.find(user_id)
    #   user.remove_role "#{Role.find(role_id).name}"
    # end
end
