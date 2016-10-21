module Admin
  class DocumentsController < ApplicationController
    before_action :set_document, only: [:show, :edit, :update, :destroy, :remove_document, :restore_document]
    before_action :authenticate_user!
    # before_action :check_role?
    load_and_authorize_resource
    # GET /documents
    # GET /documents.json
    def index
      @documents = Document.where("deleted = ?", false).order(created_at: :desc)
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
      @document.user_id = current_user.id

      respond_to do |format|
        if @document.save
          Log.create! description: "#{current_user.email} uploaded #{@document.name} at #{@document.created_at}", role_id: current_user.roles.ids.first

          # group = Group.find(params[:document][:group_id])
          # DocumentsNotifierMailer.new_doc_notification(@document).deliver

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
          Log.create! description: "#{current_user.email} updated #{@document.name} at #{@document.updated_at}", role_id: current_user.roles.ids.first
          format.html { redirect_to admin_document_path(@document), notice: 'Document was successfully updated.' }
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
      Log.create! description: "#{current_user.email} deleted : #{@document.name} at #{Time.zone.now}", role_id: current_user.roles.ids.first
      @document.destroy
      respond_to do |format|
        format.html { redirect_to :back, notice: 'Document was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    def remove_document
      # => for removing a document not deleting it, to preserve data
      @document.deleted = true
      @document.save!

      Log.create! description: "<b>#{current_user.email} </b> removed document <b> #{@document.name} </b> at #{@document.updated_at}", role_id: current_user.roles.ids.first

      redirect_to :back, notice: "Document moved to recycle bin successfully !!"
    end

    def recycle_bin
      @documents = Document.where("deleted = ?", true).order(updated_at: :desc)
    end

    def restore_document
      # => to restore the document from recycle bin back to documents page
      @document.deleted = false
      @document.save!
      Log.create! description: "<b>#{current_user.email} </b> restored document <b> #{@document.name} </b> at #{@document.updated_at}", role_id: current_user.roles.ids.first

      redirect_to :back, notice: "Document restored from recycle bin successfully !!"

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
