module Admin

  class RolesController < ApplicationController
    before_action :authenticate_user!
    # before_action :check_role?
    load_and_authorize_resource
    def index
      @roles = Role.all
      @role = Role.new
    end

    def show
      @role = Role.find(params[:id])
      @users = @role.users
    end

    def del_role

      user = User.find(params["u_id"].to_i)
      role = Role.find(params[:id])
      user.delete_role role.name

      Log.create! description: "<b>#{current_user.email} </b> removed <b>#{user.email} </b> from role <b>#{role.name} </b> at #{Time.now.utc}", role_id: current_user.roles.ids.first

      redirect_to :back, notice: "User Removed from that role"
    end

    def create
      @role = Role.new(role_params)

      if @role.save
        Log.create! description: "<b>#{current_user.email} </b> created role : <b>#{@role.name} </b> at #{@role.created_at}", role_id: current_user.roles.ids.first
        redirect_to :back, notice: 'Role was successfully created.'
      end

    end

    def destroy
      @role = Role.find(params[:id])
      Log.create! description: "<b>#{current_user.email} </b> deleted role : <b>#{@role.name} </b> at #{Time.now.utc}", role_id: current_user.roles.ids.first
      @role.destroy

      redirect_to :back, notice: 'Role was successfully destroyed.'
    end


    private

      def role_params
        params.require(:role).permit(:name)
      end
  end

end
