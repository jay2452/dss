module Admin

  class RolesController < ApplicationController
    before_action :authenticate_user!
    before_action :check_role?
    def index
      @roles = Role.all
      @role = Role.new
    end

    def show
      @role = Role.find(params[:id])
    end

    def create
      @role = Role.new(role_params)

      if @role.save
        Log.create! description: "<b>#{current_user.email} </b> created role : <b>#{@role.name} </b> at #{@role.created_at}"
        redirect_to :back, notice: 'Role was successfully created.'
      end

    end

    def destroy
      @role = Role.find(params[:id])
      Log.create! description: "<b>#{current_user.email} </b> deleted role : <b>#{@role.name} </b> at #{Time.now.utc}"
      @role.destroy

      redirect_to :back, notice: 'Role was successfully destroyed.'
    end


    private

      def role_params
        params.require(:role).permit(:name)
      end
  end

end
