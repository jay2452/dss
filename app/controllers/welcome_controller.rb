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
      @unapproved_documents = Document.where("approved = ? and deleted = ?", false, false).order(created_at: :desc)
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
       Log.create! description: "<b>#{current_user.email} </b> approved <b>#{document.name} </b> at #{document.updated_at.strftime '%d-%m-%Y %H:%M:%S'}",
                                     role_id: current_user.roles.ids.first
     end
     redirect_to root_path, notice: "Document approved !"
  end

  def approve_from_doc_view
    doc_id = params[:id].to_i if params[:id]

    if doc_id > 0
      unapproved_document = Document.find(doc_id)
      unapproved_document.approved = true
      unapproved_document.save
      Log.create! description: "<b>#{current_user.email} </b> approved <b>#{unapproved_document.name} </b> at #{unapproved_document.updated_at.strftime '%d-%m-%Y %H:%M:%S'}",
                                    role_id: current_user.roles.ids.first
    end
    redirect_to root_path, notice: "Document Approved !"
  end
end
