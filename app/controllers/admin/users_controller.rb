module Admin

  class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :check_role?
    # load_and_authorize_resource

    def index
      @users = User.all - User.with_role(:admin) - User.with_role(:superAdmin)
      @user = User.new
      @roles = Role.all - Role.where("name = ?", "admin") - Role.where("name = ?", "superAdmin")

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
      role = Role.find(params[:role_id])
      # group = Group.first
      if @user.save
        @user.add_role role.name
        Log.create! description: "<b>#{current_user.email} </b> created user <b>#{@user.email} </b> at #{@user.created_at}"
        Log.create! description: "<b>#{current_user.email} </b> added user <b>#{@user.email} </b> to role <b>#{role.name} </b> at #{@user.created_at}"

        # ug = UserGroup.create! user_id: @user.id, group_id: group.id

        # Log.create! description: "<b>#{@user.email} </b> added to project <b>#{group.name} </b> at #{ug.created_at}"

        redirect_to :back, notice: 'User successfully added'
      end
    end

    def edit
      @user = User.friendly.find(params[:id])
    end

    def update
      @user = User.friendly.find(params[:id])
      if @user.update(user_params)
        Log.create! description: "<b>#{current_user.email} </b> updated user <b>#{@user.email} </b> password </b> at #{@user.updated_at}"
        redirect_to admin_users_path, notice: "Password Changed successfully"
      end
    end

    def destroy

      puts ")))))))))))))))))++++++++++++++++++++++++++++++++++++"
        @user = User.friendly.find(params[:id])
        p @user
      puts ")))))))))))))))))++++++++++++++++++++++++++++++++++++"


      Log.create! description: "<b>#{current_user.email} </b> removed user <b>#{@user.email} </b> #{Time.now.utc}"
      @user.destroy

      redirect_to :back, notice: 'user was successfully removed'
    end

    def add_user_role
      @user = User.find(params[:user_id])

      puts "=_____________________________________"
        puts params
      puts "==_____________________________________"
      @user.add_role "#{Role.find(params[:role_id]).name}"

      Log.create!(description: "<b>#{current_user.email}</b> assigned role <b>#{Role.find(params[:role_id]).name} </b> to <b>#{@user.email} </b>")

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
        params.require(:user).permit(:email, :password, :mobile)
      end
  end

end
