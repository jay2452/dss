module Admin

  class UsersController < ApplicationController
    def index
      @users = User.all
      @user = User.new

      @users_role = UsersRole.new
    end

    # def new
    #   @user = User.new
    # end

    def show
        @user = User.find(params[:id])
    end

    def create
      @user = User.new(user_params)

      @user.save
      redirect_to :back, notice: 'user was successfully created'
    end

    def destroy
      @user = User.find(params[:id])
      @user.destroy

      redirect_to :back, notice: 'user was successfully removed'
    end
    #
    # def remove_user_role
    #   @users_role = UserRole.where("user_id = ? AND role_id = ?", params[:user_id], params[:role_id] ).first
    #   @users_roles.destroy
    #
    #   redirect_to :back
    # end


    private

      def user_params
        params.require(:user).permit(:email, :password)
      end
  end

end
