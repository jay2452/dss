module Admin
  class GroupsController < ApplicationController
    before_action :set_group, only: [:show, :edit, :update, :destroy, :remove_user, :disable_group, :enable_group]
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
      users = User.with_role(:admin).all + User.with_role(:superAdmin).all + User.with_role(:uploadUser).all
      @users = User.all - @group.users - users - User.find_by_sql("select * from users where deleted_at IS NOT NULL")
      @documents = @group.documents.where("deleted = ?", false).order(created_at: :desc)
    end

    # GET /groups/new
    def new
      @group = Group.new
      @uploadUsers = User.with_role(:uploadUser).where("users.is_active = ?", true)
    end

    # GET /groups/1/edit
    def edit
      @uploadUsers = User.with_role(:uploadUser).where("users.is_active = ?", true)
    end

    # => add user group is in groups_controller not in admin but in common folder

    def remove_user
      user = User.friendly.find(params[:u_id])
      ug = UserGroup.where("user_id = ? AND group_id = ?", user.id, @group.id).first
      group = @group
      ug.destroy
      Log.create! description: "<b>#{current_user.email} </b> removed user <b>#{user.email} </b> from project <b>#{group.name} </b> at #{Time.zone.now.strftime '%d-%m-%Y %H:%M:%S'}",
                                  role_id: current_user.roles.ids.first
      redirect_to :back, notice: 'User successfully removed from project'
    end

    def disable_group
      # => if the group/project is disabled the users of the Project will not be able to view aany previous documents also belonging to that project
      @group.disabled = true
      if @group.save
        Log.create! description: "<b>#{current_user.email} </b> disabled project <b>#{@group.name} </b> at #{@group.updated_at.strftime '%d-%m-%Y %H:%M:%S'}",
                                            role_id: current_user.roles.ids.first
        redirect_to :back, notice: "Project successfully disabled"
      else
        redirect_to :back, alert: "Error !!, project disable failed"
      end


    end

    def enable_group
      @group.disabled = false
      if @group.save
        Log.create! description: "<b>#{current_user.email} </b> enabled project <b>#{@group.name} </b> at #{@group.updated_at.strftime '%d-%m-%Y %H:%M:%S'}",
                                            role_id: current_user.roles.ids.first
        redirect_to :back, notice: "Project successfully enabled !"
      else
        redirect_to :back, alert: "Error, could not be enabled !"
      end
    end

    # POST /groups
    # POST /groups.json
    def create
      @group = Group.new(group_params)
      @group.user_id = current_user.id #store the information of the user who created this group/project

      respond_to do |format|
        if @group.save
          Log.create! description: "<b>#{current_user.email} </b> created project <b>#{@group.name} </b> at #{@group.created_at.strftime '%d-%m-%Y %H:%M:%S'}",
                                    role_id: current_user.roles.ids.first


          ug = UserGroup.create! user_id: @group.upload_user.id, group_id: @group.id
          Log.create! description: "<b>#{current_user.email} </b> added user <b>#{@group.upload_user.email} </b> to group <b>#{@group.name} </b> at #{ug.created_at.strftime '%d-%m-%Y %H:%M:%S'}",
                                      role_id: current_user.roles.ids.first

          # => notify to the upload user about their assignment to this group (mail and sms)

          UserNotifierMailer.delay(queue: "upload user added to project").added_to_project(@group.upload_user, @group)
          # => send sms after adding user to the project
          if @group.upload_user.mobile
            send_sms(@group.upload_user.mobile, "#{@group.upload_user.roles.last.name}, You have been added to project - #{@group.name}")
          end

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

      # => check if the group name or decrption is changed, then noo need to notify the upload User
      # => but if the upload_user of that group changes then notify the neww upload user (email and sms)
      old_user = nil
      old_user = @group.upload_user.email if @group.upload_user

      respond_to do |format|
        if @group.update(group_params)
          Log.create! description: "<b>#{current_user.email} </b> updated project <b>#{@group.name} </b> at #{@group.updated_at.strftime '%d-%m-%Y %H:%M:%S'}",
                                  role_id: current_user.roles.ids.first

          new_user = @group.upload_user.email
          if old_user != new_user
            ug = UserGroup.create! user_id: @group.upload_user.id, group_id: @group.id
            Log.create! description: "<b>#{current_user.email} </b> added user <b>#{@group.upload_user.email} </b> to group <b>#{@group.name} </b> at #{ug.created_at.strftime '%d-%m-%Y %H:%M:%S'}",
                                        role_id: current_user.roles.ids.first
            # => notify the new user
            UserNotifierMailer.delay(queue: "upload user added to project").added_to_project(@group.upload_user, @group)
            # => send sms after adding user to the project
            if @group.upload_user.mobile
              send_sms(@group.upload_user.mobile, "#{@group.upload_user.roles.last.name}, You have been added to project - #{@group.name}")
            end

          end
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
        params.require(:group).permit(:name, :purpose, :upload_user_id)
      end
  end

end
