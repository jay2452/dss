module Admin
  class DocumentsController < ApplicationController
    before_action :set_document, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_user!
    before_action :check_role?
    # GET /documents
    # GET /documents.json
    def index
      @documents = Document.all.order(group_id: :desc, created_at: :desc)

      # @approved_docs = Document.where('approved = ?', true).order(created_at: :desc)
      # @unApproved_docs = Document.where('approved = ?', false).order(created_at: :desc)
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

      respond_to do |format|
        if @document.save
          Log.create! description: "#{current_user.email} uploaded #{@document.name} at #{@document.created_at}"
          format.html { redirect_to @document, notice: 'Document was successfully created.' }
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
          Log.create! description: "#{current_user.email} updadted #{@document.name} at #{@document.updated_at}"
          format.html { redirect_to @document, notice: 'Document was successfully updated.' }
          format.json { render :show, status: :ok, location: @document }
        else
          format.html { render :edit }
          format.json { render json: @document.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /documents/1
    # DELETE /documents/1.json
    def destroy
      Log.create! description: "#{current_user.email} deleted : #{@document.name} at #{Time.now.utc}"
      @document.destroy
      respond_to do |format|
        format.html { redirect_to documents_url, notice: 'Document was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_document
        @document = Document.friendly.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def document_params
        params.require(:document).permit(:name, :document_category_id)
      end
  end

end
