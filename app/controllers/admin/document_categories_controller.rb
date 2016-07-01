module Admin
  class DocumentCategoriesController < ApplicationController
    before_action :authenticate_user!
    before_action :check_role?
    def index
      @document_categories = DocumentCategory.all
      @document_category = DocumentCategory.new
    end

    def create
      @document_category = DocumentCategory.new(document_category_params)

      @document_category.save
      redirect_to :back, notice: "category was successfully created"
    end

    def destroy
      @document_category = DocumentCategory.find(params[:id])
      @document_category.destroy

      redirect_to :back, notice: "category was successfully destroyed"
    end


    private

    def document_category_params
      params.require(:document_category).permit(:name)
    end

  end

end
