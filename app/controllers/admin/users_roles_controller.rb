module Admin
  class UsersRolesController < ApplicationController
    def index
      @users_roles = UsersRole.all
    end

    def new
      @users_role = UsersRole.new

      puts "=================================================="
        puts params
      puts "=================================================="

      @u_id = params[:user_id]

      puts "=================================================="
        puts @u_id
      puts "=================================================="
    end

    def create
      @users_role = UsersRole.new(users_roles_params)
      # @users_role.user_id = @u_id
      @users_role.save
      redirect_to :back, notice: "role successfully added to user"
    end


    private
      def users_roles_params
        params.require(:users_role).permit(:role_id, :user_id)
      end
  end

end
