class DocumentsController < ApplicationController
  before_action :set_document, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  load_and_authorize_resource

  # GET /documents
  # GET /documents.json
  def index
    @documents = Document.all.order(created_at: :desc)     # where("approved = ?", true)
  end

  # GET /documents/1
  # GET /documents/1.json
  def show
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

    doc_group = params["group"]
    u_id = params["user_id"]

    respond_to do |format|
      if @document.save
        DocumentGroup.create! document_id: @document.id, group_id: doc_group.to_i
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
    if @document.user == current_user
      Log.create! description: "<b>#{current_user.email} </b> deleted document <b>#{@document.name} </b> at #{Time.now.utc}"
      @document.destroy
      respond_to do |format|
        format.html { redirect_to documents_url, notice: 'Document was successfully destroyed.' }
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
      params.require(:document).permit(:name, :document_category_id, :file, :user_id)
    end

end
