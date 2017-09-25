module Admin
  class DocumentsController < ApplicationController
    before_action :set_document, only: [:show, :edit, :update, :destroy, :remove_document, :restore_document, :change_ownership]
    before_action :authenticate_user!
    # before_action :check_role?
    load_and_authorize_resource
    # GET /documents
    # GET /documents.json
    def index
      @documents = Document.where("deleted = ?", false).paginate(:page => params[:page], :per_page => 10).order(created_at: :desc)

    end

    # GET /documents/1
    # GET /documents/1.json
    def show
      @uploadUsers = User.with_role(:uploadUser).where("users.is_active = ?", true)
    end

    # GET /documents/new
    def new
      @document = Document.new
      @groups = Group.where("disabled = ?", false).all
    end

    # GET /documents/1/edit
    def edit
      @groups = Group.where("disabled = ?", false).all
    end

    # POST /documents
    # POST /documents.json
    def create
      @groups = Group.all.where("disabled = ?", false)
      @document = Document.new(document_params)
      @document.user_id = current_user.id

      respond_to do |format|
        if @document.save
          Log.create! description: "#{current_user.email} uploaded #{@document.name} at #{@document.created_at.strftime '%d-%m-%Y %H:%M:%S'}", role_id: current_user.roles.ids.first

          user_groups = @document.group.user_groups.where("is_approver = ?", true)
          users = []
          user_groups.each do |ug|
            users << ug.user
          end

          users.each do |approver|
            # => send sms to user mobile numbers
            if approver.mobile?
              send_sms(approver.mobile, "#{approver.roles.last.name}, New Document - #{@document.name} -uploaded in project folder - #{@document.group.name}, please see the document !!")
            end

            # DocumentsNotifierMailer.notify_approver(@document, approver.email).deliver
            DocumentsNotifierMailer.delay(queue: "notify approver").notify_approver(@document, approver.email)
          end

          format.html { redirect_to admin_document_path(@document), notice: 'Document was successfully created.' }
          format.json { render :show, status: :created, location: @document }
        else
          format.html { render :new }
          format.json { render json: @document.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /documents/1
    # PATCH/PUT /documents/1.json
    def update
      respond_to do |format|
        if @document.update(document_params)
          Log.create! description: "#{current_user.email} updated #{@document.name} at #{@document.updated_at.strftime '%d-%m-%Y %H:%M:%S'}", role_id: current_user.roles.ids.first
          format.html { redirect_to admin_document_path(@document), notice: 'Document was successfully updated.' }
          format.json { render :show, status: :ok, location: @document }
        else
          format.html { render :edit }
          format.json { render json: @document.errors, status: :unprocessable_entity }
        end
      end
    end

    def change_ownership
      previous_user = @document.user

      u_id = params[:user].to_i
      @document.user_id = u_id
      if @document.save
        Log.create! description: "<b>#{current_user.email}</b> transfered the ownership of document : <b>#{@document.name}</b> from #{previous_user.email} to <b>#{@document.user.email}</b> at #{Time.zone.now.strftime '%d-%m-%Y %H:%M:%S'}", role_id: current_user.roles.ids.first

        # => notify the users
        if previous_user.mobile? && previous_user.is_active?
          send_sms(previous_user.mobile, "#{previous_user.roles.last.name}, Your Document - #{@document.name} -has been assigned to a new user. You are now not asigned with that document")
        end
        if previous_user.is_active?
          DocumentsNotifierMailer.delay(queue: "notify change ownerships").notify_previous_owner(@document, previous_user.email)
        end

        if @document.user.mobile?
          send_sms(@document.user.mobile, "#{@document.user.roles.last.name}, You have been asigned to a new Document - #{@document.name} - please check the document .")
        end
        DocumentsNotifierMailer.delay(queue: "notify change ownerships").notify_new_owner(@document, @document.user.email)

        redirect_back fallback_location: root_path, notice: "Ownership of document changed !!"
      else
        redirect_back fallback_location: root_path, alert: "Can't be changed"
      end
    end

    # DELETE /documents/1
    # DELETE /documents/1.json
    def destroy
      Log.create! description: "<b>#{current_user.email}</b> deleted : <b>#{@document.name}</b> at #{Time.zone.now.strftime '%d-%m-%Y %H:%M:%S'}", role_id: current_user.roles.ids.first
      @document.destroy
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, notice: 'Document was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    def remove_document
      # => for removing a document not deleting it, to preserve data
      @document.deleted = true
      @document.save!

      Log.create! description: "<b>#{current_user.email} </b> removed document <b> #{@document.name} </b> at #{@document.updated_at.strftime '%d-%m-%Y %H:%M:%S'}", role_id: current_user.roles.ids.first

      redirect_back fallback_location: root_path, notice: "Document moved to recycle bin successfully !!"
    end

    def recycle_bin
      @documents = Document.where("deleted = ?", true).order(updated_at: :desc)
    end

    def restore_document
      # => to restore the document from recycle bin back to documents page
      @document.deleted = false
      @document.save!
      Log.create! description: "<b>#{current_user.email} </b> restored document <b> #{@document.name} </b> at #{@document.updated_at.strftime '%d-%m-%Y %H:%M:%S'}", role_id: current_user.roles.ids.first

      redirect_back fallback_location: root_path, notice: "Document restored from recycle bin successfully !!"

    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_document
        @document = Document.friendly.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def document_params
        params.require(:document).permit(:name, :group_id, :file, :user_id)
      end
  end

end
