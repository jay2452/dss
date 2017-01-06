module Admin
  class UsersRolesController < ApplicationController
    before_action :authenticate_user!
    before_action :check_role?
    # load_and_authorize_resource

    def index
      @users_roles = UsersRole.all.order(role_id: :desc)
    end

    def new
      @users_role = UsersRole.new
      @roles = Role.where.not("name = ? OR name = ?", "admin", "superAdmin")
    end

    def create
       u_id = params[:users_role][:user_id]

       user = User.friendly.find u_id

      user.roles.each do |role|
        user.delete_role role.name
      end

      @users_role = UsersRole.new(users_roles_params)
      # => if the role is changed from view user to upload user , then the user must be removed from all the projects
      if @users_role.role.name == "uploadUser" # => then remove user from all projects
        user_groups = UserGroup.where("user_id = ? AND group_id IN (?)", user.id, user.groups.ids)
        user_groups.each do |ug|
          Log.create! description: "<b>#{current_user.email} </b> deleted user <b>#{user.email} </b> from project <b>#{ug.group.name} </b> at
                                                                    #{Time.zone.now.strftime '%d-%m-%Y %H:%M:%S'}", role_id: current_user.roles.ids.first
          ug.destroy
        end
      end

      @users_role.user_id = user.id

      if @users_role.save
        redirect_to admin_users_path, notice: "Role changed !!"
      else
        redirect_to :back, notice: "Role cannot be added"
      end

    end

    def destroy
      @user = User.find(params[:id])

      @user.delete_role "#{params[:role_name]}"

      redirect_to :back, notice: "Role Removed"
    end


    private
      def users_roles_params
        params.require(:users_role).permit(:role_id, :user_id)
      end
  end

end
