module Admin

  class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :check_role?

    def index
      @users = User.all
      @user = User.new
      @roles = Role.all

      @users_role = UsersRole.new
    end

    # def new
    #   @user = User.new
    # end

    def show
        @user = User.friendly.find(params[:id])
        @roles = Role.all
        @groups = Group.all
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

    def add_user_role
      @user = User.find(params[:user_id])

      puts "=_____________________________________"
        puts params
      puts "==_____________________________________"
      @user.add_role "#{Role.find(params[:role_id]).name}"

      redirect_to :back
    end
    #
    # def add_sms_group
    #   @user = User.find(params[:user_id])
    #   @groups = Group.all
    #   puts "====================================="
    #     puts params
    #   puts "====================================="
    #   # UserGroup.create! @user.id,
    #   # redirect_to :back
    # end

    private

      def user_params
        params.require(:user).permit(:email, :password)
      end
  end

end
