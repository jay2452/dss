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



    private

      def user_params
        params.require(:user).permit(:email, :password)
      end
  end

end
