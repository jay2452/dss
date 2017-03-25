class DocumentsController < ApplicationController
  before_action :set_document, only: [:show, :edit, :update, :destroy, :send_doc, :download_doc, :show_doc]
  before_action :authenticate_user!
  load_and_authorize_resource
  # before_action :check_role?

  # GET /documents
  # GET /documents.json
  def index
    @documents = Document.all.order(group_id: :desc)     # where("approved = ?", true)
    @doc_groups = DocumentGroup.all.order(created_at: :desc)
  end

  def send_doc
    dg = DocumentGroup.new(document_id: @document.id, group_id: @document.group.id, user_id: current_user.id)
    if dg.save
      Log.create! description: "<b>#{current_user.email} </b> sent document <b>#{dg.document.name} </b> to project
                            #{dg.group.name} at #{dg.created_at.strftime '%d-%m-%Y %H:%M:%S'}", role_id: current_user.roles.ids.first

      # => send mail to all the users in the project

      Group.find(@document.group_id).users.pluck(:email).each do |user|
        # => check if the user is disabled or not
        user_obj = User.find_by_email(user)
        if user_obj.deleted_at?
          # => donot send email
          puts "User is disabled"
        else
          DocumentsNotifierMailer.delay(queue: "send document").new_doc_notification(@document, user)
          # DocumentsNotifierMailer.new_doc_notification(@document, user).deliver
          if user_obj.mobile
            # => send sms to user mobile numbers
            send_sms(user_obj.mobile, "#{user_obj.roles.last.name}, New Document - #{@document.name} -received in project folder - #{@document.group.name}")
          end
        end
      end
      redirect_to :back, notice: "Successfully sent"
    else
      redirect_to :back, alert: "Not Sent"
    end
  end

  def show_doc

  end

  def download_doc
    case @document.file_content_type
      when 'application/pdf'
        send_file @document.file.path, filename: "#{@document.name}.pdf", type: 'pdf'
      when 'image/jpeg'
        send_file @document.file.path, filename: "#{@document.name}.jpeg", type: 'jpeg'
      when 'image/jpg'
        send_file @document.file.path, filename: "#{@document.name}.jpg", type: 'jpg'
      when 'image/gif'
        send_file @document.file.path, filename: "#{@document.name}.gif", type: 'gif'
      when 'image/png'
        send_file @document.file.path, filename: "#{@document.name}.png", type: 'png'
    end
  end

  # GET /documents/1
  # GET /documents/1.json
  def show
    # current_user
    # => status 1 means the document is read
    uds = UserDocumentStatus.new user_id: current_user.id, document_id: @document.id, status: 1
    if uds.save
      Log.create! description: "<b>#{current_user.email} </b> opened the document <b>#{@document.name} </b> at #{uds.created_at.strftime '%d-%m-%Y %H:%M:%S'}",
                      role_id: current_user.roles.ids.first
    end
  end

  # GET /documents/new
  def new
    @document = Document.new
    @groups = Group.all.where("disabled = ?", false)
  end

  # GET /documents/1/edit
  def edit
    @groups = Group.all.where("disabled = ?", false)
  end

  # POST /documents
  # POST /documents.json
  def create
    @groups = Group.all.where("disabled = ?", false)
    @document = Document.new(document_params)
    @document.user_id = current_user.id

    # doc_group = params["group"]
    # u_id = params["user_id"]

    respond_to do |format|
      if @document.save
        # DocumentGroup.create! document_id: @document.id, group_id: doc_group.to_i
        Log.create! description: "<b>#{current_user.email} </b> uploaded <b>#{@document.name} </b> at #{@document.created_at.strftime '%d-%m-%Y %H:%M:%S'}",
                                      role_id: current_user.roles.ids.first

        # => after uploading the document , notify the approve user to approve the document, then after that the approve user will be able to
        # => send the document to the group members

        #find who are the approvers for that document

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
          DocumentsNotifierMailer.delay(queue: "send document to approver").notify_approver(@document, approver.email)
        end

        format.html { redirect_to @document, notice: 'Document successfully uploaded and sent to be approved.' }
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
    if @document.user == current_user
      respond_to do |format|
        if @document.update(document_params)
          Log.create! description: "<b>#{current_user.email} </b> updated <b>#{@document.name} </b> at #{@document.updated_at.strftime '%d-%m-%Y %H:%M:%S'}",
                              role_id: current_user.roles.ids.first
          format.html { redirect_to @document, notice: 'Document successfully updated.' }
          format.json { render :show, status: :ok, location: @document }
        else
          format.html { render :edit }
          format.json { render json: @document.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /documents/1
  # DELETE /documents/1.json
  def destroy
    if (@document.user == current_user)
      Log.create! description: "<b>#{current_user.email} </b> deleted document <b>#{@document.name} </b> at #{Time.zone.now.strftime '%d-%m-%Y %H:%M:%S'}",
                                role_id: current_user.roles.ids.first
      @document.destroy
      respond_to do |format|
        format.html { redirect_to :back, notice: 'Document successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  # => approved documents list for tha upload user only
  def approved_documents
    if current_user.has_role? :uploadUser
      @documents = Document.where("approved = ? and deleted = ?", true, false).order(approved_at: :desc)
    else
      redirect_to root_path
    end
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
