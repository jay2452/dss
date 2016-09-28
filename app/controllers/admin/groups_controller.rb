module Admin
  class GroupsController < ApplicationController
    before_action :set_group, only: [:show, :edit, :update, :destroy, :remove_user]
    before_action :authenticate_user!
    # before_action :check_role?
    load_and_authorize_resource

    # GET /groups
    # GET /groups.json
    def index
      @groups = Group.all.order(created_at: :desc)
    end

    # GET /groups/1
    # GET /groups/1.json
    def show
      @users = User.all - @group.users
      @documents = @group.documents.order(created_at: :desc)
    end

    # GET /groups/new
    def new
      @group = Group.new
    end

    # GET /groups/1/edit
    def edit
    end

    def remove_user
      user = User.friendly.find(params[:u_id])
      ug = UserGroup.where("user_id = ? AND group_id = ?", user.id, @group.id).first
      group = @group
      ug.destroy
      Log.create! description: "<b>#{current_user.email} </b> removed user <b>#{user.email} </b> from project <b>#{group.name} </b> at #{Time.now.utc}"
      redirect_to :back, notice: 'User successfully removed from project'

    end

    # POST /groups
    # POST /groups.json
    def create
      @group = Group.new(group_params)
      @group.user_id = current_user.id

      respond_to do |format|
        if @group.save
          Log.create! description: "<b>#{current_user.email} </b> created group <b>#{@group.name} </b> at #{@group.created_at}"
          format.html { redirect_to admin_groups_path, notice: 'Group was successfully created.' }
          format.json { render :show, status: :created, location: @group }
        else
          format.html { render :new }
          format.json { render json: @group.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /groups/1
    # PATCH/PUT /groups/1.json
    def update
      respond_to do |format|
        if @group.update(group_params)
          Log.create! description: "<b>#{current_user.email} </b> updated group <b>#{@group.name} </b> at #{@group.updated_at}"
          format.html { redirect_to admin_groups_path, notice: 'Group was successfully updated.' }
          format.json { render :show, status: :ok, location: @group }
        else
          format.html { render :edit }
          format.json { render json: @group.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /groups/1
    # DELETE /groups/1.json
    def destroy
      Log.create! description: "<b>#{current_user.email} </b> deleted group <b>#{@group.name} </b> at #{Time.now.utc}"
      @group.destroy
      respond_to do |format|
        format.html { redirect_to admin_groups_url, notice: 'Group was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_group
        @group = Group.friendly.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def group_params
        params.require(:group).permit(:name, :purpose)
      end
  end

end
