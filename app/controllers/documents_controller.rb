class DocumentsController < ApplicationController
  before_action :set_document, only: [:show, :edit, :update, :destroy, :send_doc, :download_doc]
  before_action :authenticate_user!
  load_and_authorize_resource
  # before_action :check_role?

  # GET /documents
  # GET /documents.json
  def index
    @documents = Document.all.order(group_id: :desc)     # where("approved = ?", true)
    @doc_groups = DocumentGroup.all.order(created_at: :desc)
  end

  # def add_doc_to_group
  #   doc = params["document"].to_i
  #   group = params["group"].to_i
  #
  #   dg = DocumentGroup.create! document_id: doc, group_id: group
  #   Log.create! description: "<b>#{current_user.email} </b> sent document <b>#{dg.document.name} </b> to project #{dg.group.name} at #{dg.created_at}"
  #
  #   redirect_to :back, notice: "Successfully sent"
  # end

  def send_doc
    dg = DocumentGroup.create! document_id: @document.id, group_id: @document.group.id
    Log.create! description: "<b>#{current_user.email} </b> sent document <b>#{dg.document.name} </b> to project #{dg.group.name} at #{dg.created_at}"
    redirect_to :back, notice: "Successfully sent"
  end

  def download_doc
    send_file @document.file.path, filename: "#{@document.name}.pdf", type: 'pdf'
  end

  # GET /documents/1
  # GET /documents/1.json
  def show
    # current_user
    # => status 1 means the document is read
    uds = UserDocumentStatus.new user_id: current_user.id, document_id: @document.id, status: 1
    if uds.save
      Log.create! description: "<b>#{current_user.email} </b> opened the document <b>#{@document.name} </b> at #{uds.created_at}"
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
        Log.create! description: "<b>#{current_user.email} </b> uploaded <b>#{@document.name} </b> at #{@document.created_at}"
        format.html { redirect_to @document, notice: 'Document was successfully created.' }
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
          Log.create! description: "<b>#{current_user.email} </b> updated <b>#{@document.name} </b> at #{@document.updated_at}"
          format.html { redirect_to @document, notice: 'Document was successfully updated.' }
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
      Log.create! description: "<b>#{current_user.email} </b> deleted document <b>#{@document.name} </b> at #{Time.now.utc}"
      @document.destroy
      respond_to do |format|
        format.html { redirect_to :back, notice: 'Document was successfully destroyed.' }
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
