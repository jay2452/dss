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

      if @user.save
        @user.add_role role.name
        Log.create! description: "<b>#{current_user.email} </b> created user <b>#{@user.email} </b> at #{@user.created_at.strftime '%d-%m-%Y %H:%M:%S'}", role_id: current_user.roles.ids.first
        Log.create! description: "<b>#{current_user.email} </b> added user <b>#{@user.email} </b> to role <b>#{role.name} </b> at #{@user.created_at.strftime '%d-%m-%Y %H:%M:%S'}", role_id: current_user.roles.ids.first

        # ug = UserGroup.create! user_id: @user.id, group_id: group.id

        # Log.create! description: "<b>#{@user.email} </b> added to project <b>#{group.name} </b> at #{ug.created_at}"

        # => code to send email or notify the user/member
        pwd = params[:user][:password]
        UserNotifierMailer.account_create_notification(@user, pwd).deliver

        # => code to send sms to the created user
        if @user.mobile
          send_sms(@user.mobile, "User account created on GPIL e-portal, please check your email for further info.")
        end

        redirect_to :back, notice: 'User successfully added'
      end
    end

    def edit
      @user = User.friendly.find(params[:id])
    end

    def update
      @user = User.friendly.find(params[:id])
      if @user.update(user_params)
        Log.create! description: "<b>#{current_user.email} </b> updated user <b>#{@user.email} </b> password </b> at #{@user.updated_at.strftime '%d-%m-%Y %H:%M:%S'}", role_id: current_user.roles.ids.first

        pwd = params[:user][:password]
        UserNotifierMailer.account_update_notification(@user, pwd).deliver # => send updated mail for account updation

        if @user.mobile
          send_sms(@user.mobile, "User account is updated on GPIL e-portal, please check your email for further info.")
        end
        redirect_to admin_users_path, notice: "Password Changed successfully"
      end
    end

    def disable_user
      @user = User.friendly.find(params[:id])
      @user.soft_delete
      Log.create! description: "<b>#{current_user.email} </b> disabled user <b>#{@user.email}</b> at#{@user.updated_at.strftime '%d-%m-%Y %H:%M:%S'}", role_id: current_user.roles.ids.first
      redirect_to :back, notice: "User removed from the system"
    end

    def enable_user
      @user = User.friendly.find(params[:id])
      @user.deleted_at = nil
      if @user.save
        Log.create! description: "<b>#{current_user.email} </b> enabled user <b>#{@user.email}</b> at#{@user.updated_at.strftime '%d-%m-%Y %H:%M:%S'}", role_id: current_user.roles.ids.first
        redirect_to :back, notice: "User account enabled !"
      else
        redirect_to :back, alert: "Error, please try agian"
      end
    end

    def destroy
      @user = User.friendly.find(params[:id])
      Log.create! description: "<b>#{current_user.email} </b> removed user <b>#{@user.email} </b> at #{Time.zone.now.strftime '%d-%m-%Y %H:%M:%S'}", role_id: current_user.roles.ids.first
      @user.destroy
      redirect_to :back, notice: 'user was successfully removed'
    end


    def add_user_role
      @user = User.find(params[:user_id])
      @user.add_role "#{Role.find(params[:role_id]).name}"
      Log.create!(description: "<b>#{current_user.email}</b> assigned role <b>#{Role.find(params[:role_id]).name} </b> to <b>#{@user.email} </b at #{Time.zone.now.strftime '%d-%m-%Y %H:%M:%S'}>", role_id: current_user.roles.ids.first)
      redirect_to :back
    end

    private

      def user_params
        params.require(:user).permit(:email, :password, :mobile, :designation, :username)
      end
  end

end
