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
        Log.create! description: "<b>#{current_user.email} </b> deleted user <b>#{user.email} </b> from role <b>#{role.name} </b> at #{Time.zone.now.strftime '%d-%m-%Y %H:%M:%S'}", role_id: current_user.roles.ids.first
          # => send updated mail for role removaal
          # p  UserNotifierMailer.removed_from_role(user, role.name).deliver

          UserNotifierMailer.delay(queue: "removed from role").removed_from_role(user, role.name)
        if user.mobile
          send_sms(user.mobile, "#{user.roles.last.name}, You have been removed from role #{role.name}")
        end
      end

      @users_role = UsersRole.new(users_roles_params)
      # => if the role is changed from view user to upload user , then the user must be removed from all the projects
      if @users_role.role.name == "uploadUser" # => then remove user from all projects
        user_groups = UserGroup.where("user_id = ? AND group_id IN (?)", user.id, user.groups.ids)
        user_groups.each do |ug|
          Log.create! description: "<b>#{current_user.email} </b> deleted user <b>#{user.email} </b> from project <b>#{ug.group.name} </b> at #{Time.zone.now.strftime '%d-%m-%Y %H:%M:%S'}", role_id: current_user.roles.ids.first
          ug.destroy
        end
      end

      @users_role.user_id = user.id
      if @users_role.save
        # => create a log and send email and sms to the user
        Log.create! description: "<b>#{current_user.email} </b> added user <b>#{user.email} </b> to role <b>#{Role.find(@users_role.role_id).name} </b> at #{Time.zone.now.strftime '%d-%m-%Y %H:%M:%S'}", role_id: current_user.roles.ids.first

        # UserNotifierMailer.added_to_role(user, Role.find(@users_role.role_id).name).deliver

        UserNotifierMailer.delay(queue: "added to role").added_to_role(user, Role.find(@users_role.role_id).name)
        if user.mobile
          send_sms(user.mobile, "#{user.roles.last.name}, You have been added to role #{Role.find(@users_role.role_id).name}")
        end
        redirect_to admin_users_path, notice: "Role changed !!"
      else
        redirect_back fallback_location: root_path, notice: "Role cannot be added"
      end

    end

    def destroy
      @user = User.find(params[:id])

      @user.delete_role "#{params[:role_name]}"

      redirect_back fallback_location: root_path, notice: "Role Removed"
    end


    private
      def users_roles_params
        params.require(:users_role).permit(:role_id, :user_id)
      end
  end

end
