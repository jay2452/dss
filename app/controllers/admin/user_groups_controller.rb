module Admin
  class UserGroupsController < ApplicationController
    before_action :set_user_group, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_user!
    before_action :check_role?
    load_and_authorize_resource
    # GET /user_groups
    # GET /user_groups.json
    def index
      @user_groups = UserGroup.all
    end

    # GET /user_groups/1
    # GET /user_groups/1.json
    def show
    end

    # GET /user_groups/new
    def new
      @user_group = UserGroup.new
    end

    # GET /user_groups/1/edit
    def edit
    end

    # POST /user_groups
    # POST /user_groups.json
    def create
      @user_group = UserGroup.new(user_group_params)

      respond_to do |format|
        if @user_group.save
          Log.create! description: "<b>#{current_user.email} </b> added user <b>#{@user_group.user.email} </b> to project <b>#{@user_group.group} </b> at
                                                                    #{@user_group.created_at.strftime '%d-%m-%Y %H:%M:%S'}", role_id: current_user.roles.ids.first
          format.html { redirect_to admin_user_groups_path, notice: 'User group was successfully created.' }
          format.json { render :show, status: :created, location: @user_group }
        else
          format.html { render :new }
          format.json { render json: @user_group.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /user_groups/1
    # PATCH/PUT /user_groups/1.json
    def update
      respond_to do |format|
        if @user_group.update(user_group_params)
          Log.create! description: "<b>#{current_user.email} </b> update user <b>#{@user_group.user.email} </b> to project <b>#{@user_group.group} </b> at
                                                                    #{@user_group.updated_at.strftime '%d-%m-%Y %H:%M:%S'}", role_id: current_user.roles.ids.first
          format.html { redirect_to @user_group, notice: 'User group was successfully updated.' }
          format.json { render :show, status: :ok, location: @user_group }
        else
          format.html { render :edit }
          format.json { render json: @user_group.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /user_groups/1
    # DELETE /user_groups/1.json
    def destroy
      Log.create! description: "<b>#{current_user.email} </b> deleted user <b>#{@user_group.user.email} </b> from project <b>#{@user_group.group} </b> at
                                                                #{Time.zone.now.strftime '%d-%m-%Y %H:%M:%S'}", role_id: current_user.roles.ids.first
      @user_group.destroy
      respond_to do |format|
        format.html { redirect_to admin_user_groups_url, notice: 'User group was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_user_group
        @user_group = UserGroup.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def user_group_params
        params.require(:user_group).permit(:user_id, :group_id)
      end
  end

end
