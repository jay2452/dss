class GroupsController < ApplicationController
    before_action :set_group, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_user!
    load_and_authorize_resource
    # GET /groups
    # GET /groups.json
    def index
      @groups = Group.all.order(created_at: :desc)
    end

    # GET /groups/1
    # GET /groups/1.json
    def show
      @users = User.all
      @documents = @group.documents.order(created_at: :desc)
    end

    def add_user_to_group

      g_id = Group.find_by_name(params["group"]).id
      u_id = params["user"].to_i

      @ug = UserGroup.create! user_id: u_id, group_id: g_id
      Log.create! description: "<b>#{current_user.email} </b> added user <b>#{User.find(u_id).email} </b> to
                        group <b>#{Group.find(g_id).name} </b> at #{@ug.created_at.strftime '%d-%m-%Y %H:%M:%S'}", role_id: current_user.roles.ids.first

      UserNotifierMailer.added_to_project(User.find(u_id), Group.find(g_id)).deliver
      # => send sms after adding user to the project
      if User.find(u_id).mobile
        send_sms(User.find(u_id).mobile, "You have been added to project - #{Group.find(g_id).name}")
      end


      redirect_to :back, notice: "User Added to project"
    end

    # GET /groups/new
    def new
      @group = Group.new
    end

    # GET /groups/1/edit
    def edit
    end

    # POST /groups
    # POST /groups.json
    def create
      @group = Group.new(group_params)
      @group.user_id = current_user.id
      respond_to do |format|
        if @group.save
          Log.create! description: "<b>#{current_user.email} </b> created group <b>#{@group.name} </b> at #{@group.created_at.strftime '%d-%m-%Y %H:%M:%S'}", role_id: current_user.roles.ids.first
          format.html { redirect_to groups_path, notice: 'Group was successfully created.' }
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
          Log.create! description: "<b>#{current_user.email} </b> updated group <b>#{@group.name} </b> at #{@group.updated_at.strftime '%d-%m-%Y %H:%M:%S'}", role_id: current_user.roles.ids.first
          format.html { redirect_to @group, notice: 'Group was successfully updated.' }
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
      Log.create! description: "<b>#{current_user.email} </b> deleted group <b>#{@group.name} </b> at #{Time.zone.now.strftime '%d-%m-%Y %H:%M:%S'}", role_id: current_user.roles.ids.first
      @group.destroy
      respond_to do |format|
        format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
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
