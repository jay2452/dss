module Admin
  class GroupsController < ApplicationController
    before_action :set_group, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_user!
    before_action :check_role?

    # GET /groups
    # GET /groups.json
    def index
      @groups = Group.all
    end

    # GET /groups/1
    # GET /groups/1.json
    def show
      @users = User.all
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
          Log.create! description: "#{current_user.email} created group #{@group.name} at #{@group.created_at}"
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
          Log.create! description: "#{current_user.email} updated group #{@group.name} at #{@group.updated_at}"
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
      Log.create! description: "#{current_user.email} deleted group #{@group.name} at #{Time.now.utc}"
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
