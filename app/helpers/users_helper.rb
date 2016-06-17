module UsersHelper

  def fetch_roles(id)
    user = User.find(id)
    user_role = user.roles.map(&:name)
  end
end
