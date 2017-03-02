class WelcomeController < ApplicationController
  before_action :authenticate_user!, except: :upgrade

  def index
    @users = User.all.order(created_at: :desc)  - User.with_role(:admin) - User.with_role(:superAdmin)

    @groups = Group.limit(4).order(created_at: :desc)
    @documents = Document.where("deleted = ?", false).all.order(created_at: :desc)
    @doc_groups = DocumentGroup.all.order(created_at: :desc)
  end

  def search
  end

  def upgrade

  end

  def doc_approval
    if(current_user.has_role? :approveUser)
      @documents = Document.where("deleted = ?", false).all.order(created_at: :desc)

      @unapproved_documents = Document.where("approved = ? and deleted = ?", false, false)
    end

  end

  def approve
    idArray = []
     params.each do |key, value|
       idArray << key.to_i if value.to_i==1
     end
     toBeApprovedDocuments = Document.where("id IN (?)", idArray)
     toBeApprovedDocuments.each do |document|
       document.approved = true
       document.save
     end
     redirect_to root_path
  end
end
