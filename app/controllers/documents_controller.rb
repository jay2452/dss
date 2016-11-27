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
        DocumentsNotifierMailer.new_doc_notification(@document, user).deliver
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
  end

  # GET /documents/1/edit
  def edit
  end

  # POST /documents
  # POST /documents.json
  def create
    @document = Document.new(document_params)
    @document.user_id = current_user.id

    # doc_group = params["group"]
    # u_id = params["user_id"]

    respond_to do |format|
      if @document.save
        # DocumentGroup.create! document_id: @document.id, group_id: doc_group.to_i
        Log.create! description: "<b>#{current_user.email} </b> uploaded <b>#{@document.name} </b> at #{@document.created_at.strftime '%d-%m-%Y %H:%M:%S'}",
                                      role_id: current_user.roles.ids.first
        # DocumentsNotifierMailer.new_doc_notification(@document).deliver
        format.html { redirect_to @document, notice: 'Document successfully uploaded.' }
        format.json { render :show, status: :created, location: @document }
        # send a sms to the users
        # pass = ENV['MOSTO_PASS']
        # puts "--------------------------------\n-#{pass} +++++++++++"
        # send_sms_to params[:number]

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
