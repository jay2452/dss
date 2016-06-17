module Admin

  class RolesController < ApplicationController
    def index
      @roles = Role.all
      @role = Role.new
    end

    def add_role

    end

    def create
      @role = Role.new(role_params)

      @role.save
      redirect_to :back, notice: 'Role was successfully created.'
    end

    def destroy
      @role = Role.find(params[:id])
      @role.destroy
      redirect_to :back, notice: 'Role was successfully destroyed.'
    end


    private

      def role_params
        params.require(:role).permit(:name)
      end
  end

end
