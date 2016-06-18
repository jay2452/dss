module Admin
  class UsersRolesController < ApplicationController
    def index
      @users_roles = UsersRole.all
    end

    def new
      @users_role = UsersRole.new
    end

    def create
      @users_role = UsersRole.new(users_roles_params)
      # @users_role.user_id = @u_id
      @users_role.save
      redirect_to :back, notice: "role successfully added to user"
    end

    def destroy
      @user = User.find(params[:id])

      @user.delete_role "#{params[:role_name]}"

      redirect_to :back, notice: "role removed"
    end


    private
      def users_roles_params
        params.require(:users_role).permit(:role_id, :user_id)
      end
  end

end
