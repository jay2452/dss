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
       u_id = params[:users_role][:user_id].to_i
       user = User.find u_id

      user.roles.each do |role|
        user.delete_role role.name
      end

      @users_role = UsersRole.new(users_roles_params)

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
