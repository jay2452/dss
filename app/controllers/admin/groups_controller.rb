module Admin
  class GroupsController < ApplicationController
    before_action :set_group, only: [:show, :edit, :update, :destroy, :remove_user, :disable_group]
    before_action :authenticate_user!
    # before_action :check_role?
    load_and_authorize_resource

    # GET /groups
    # GET /groups.json
    def index
      @groups = Group.all.paginate(:page => params[:page], :per_page => 10).order(created_at: :desc)
    end

    # GET /groups/1
    # GET /groups/1.json
    def show
      users = User.with_role(:admin).all + User.with_role(:superAdmin).all
      @users = User.all - @group.users - users - User.find_by_sql("select * from users where deleted_at IS NOT NULL")
      @documents = @group.documents.order(created_at: :desc)
    end

    # GET /groups/new
    def new
      @group = Group.new
    end

    # GET /groups/1/edit
    def edit
    end

    # => add user group is in groups_controller not in admin but in common folder

    def remove_user
      user = User.friendly.find(params[:u_id])
      ug = UserGroup.where("user_id = ? AND group_id = ?", user.id, @group.id).first
      group = @group
      ug.destroy
      Log.create! description: "<b>#{current_user.email} </b> removed user <b>#{user.email} </b> from project
                                  <b>#{group.name} </b> at #{Time.zone.now.strftime '%d-%m-%Y %H:%M:%S'}", role_id: current_user.roles.ids.first
      redirect_to :back, notice: 'User successfully removed from project'
    end

    def disable_group
      @group.update(disabled: true)
      Log.create! description: "<b>#{current_user.email} </b> disabled project <b>#{@group.name} </b> at #{@group.updated_at.strftime '%d-%m-%Y %H:%M:%S'}",
                                          role_id: current_user.roles.ids.first
      redirect_to :back, notice: "Project successfully disabled"
    end

    # POST /groups
    # POST /groups.json
    def create
      @group = Group.new(group_params)
      @group.user_id = current_user.id

      respond_to do |format|
        if @group.save
          Log.create! description: "<b>#{current_user.email} </b> created project <b>#{@group.name} </b> at #{@group.created_at.strftime '%d-%m-%Y %H:%M:%S'}",
                                    role_id: current_user.roles.ids.first
          format.html { redirect_to admin_groups_path, notice: 'Project was successfully created.' }
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
          Log.create! description: "<b>#{current_user.email} </b> updated project <b>#{@group.name} </b> at #{@group.updated_at.strftime '%d-%m-%Y %H:%M:%S'}",
                                  role_id: current_user.roles.ids.first
          format.html { redirect_to admin_groups_path, notice: 'Project was successfully updated.' }
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
      Log.create! description: "<b>#{current_user.email} </b> deleted project <b>#{@group.name} </b> at #{Time.zone.now.strftime '%d-%m-%Y %H:%M:%S'}",
                              role_id: current_user.roles.ids.first
      @group.destroy
      respond_to do |format|
        format.html { redirect_to admin_groups_url, notice: 'Project was successfully destroyed.' }
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
