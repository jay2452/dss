module Admin
  class DocumentCategoriesController < ApplicationController
    before_action :authenticate_user!
    before_action :check_role?
    load_and_authorize_resource
    def index
      @document_categories = DocumentCategory.all
      @document_category = DocumentCategory.new
    end

    def create
      @document_category = DocumentCategory.new(document_category_params)

      if @document_category.save
        Log.create! description: "<b>#{current_user.email} </b> created document category <b>#{@document_category.name} </b>
                                                            at #{@document_category.created_at}"
        redirect_to :back, notice: "category was successfully created"
      end
    end

    def destroy
      @document_category = DocumentCategory.find(params[:id])
      Log.create! description: "<b>#{current_user.email} </b> deleted document category <b>#{@document_category.name} </b>
                                                          at #{@document_category.created_at}"
      @document_category.destroy

      redirect_to :back, notice: "category was successfully destroyed"
    end


    private

    def document_category_params
      params.require(:document_category).permit(:name)
    end

  end

end
