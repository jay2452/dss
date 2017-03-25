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
      @projects = current_user.groups.where("disabled = ?", false)
      # => retrieve the list of documents in those projects/groups
      project_ids = @projects.ids


      @documents = Document.where("deleted = ? and group_id IN (?)", false, project_ids).all.order(created_at: :desc)
      @unapproved_documents = Document.where("approved = ? and deleted = ? and group_id IN (?)", false, false, project_ids).order(created_at: :desc)
    end
  end

  def approver_group
    @group = Group.friendly.find(params[:id])
    # @approved_documents = @group.documents.where("approved = ? and deleted = ?", true, false)
    # @unapproved_documents = @group.documents.where("approved = ? and deleted = ?", false, false)
  end

  def approved_documents
    status = params[:approved]
    group_id = params[:group].to_i
    group = Group.find(group_id)

    if status == 'true'
      # => send the list of appproved documents
      @documents = group.documents.where("deleted = ? and approved = ?", false, true).order(updated_at: :desc)
    elsif status == 'false' # => send the list of un approved documents
      @documents = group.documents.where("approved = ? and deleted = ?", false, false).order(updated_at: :desc)
    end
  end


  def approve
    idArray = []
     params.each do |key, value|
       idArray << key.to_i if value.to_i==1
     end

     if !idArray.empty?
       toBeApprovedDocuments = Document.where("id IN (?)", idArray)
       toBeApprovedDocuments.each do |document|
         document.approved = true
         document.approved_by_user = current_user.id
         document.approved_at = Time.zone.now
         document.save
         Log.create! description: "<b>#{current_user.email} </b> approved <b>#{document.name} </b> at #{document.updated_at.strftime '%d-%m-%Y %H:%M:%S'}",
                                       role_id: current_user.roles.ids.first

        user = document.user
        # => send notification to the upload user about the approval of document
        if user.mobile?
          send_sms(user.mobile, "#{user.roles.last.name}, Document - #{document.name} -approved by- #{User.find(document.approved_by_user).email}")
        end

        DocumentsNotifierMailer.notify_uploader(document, document.user.email).deliver
      end

       redirect_to root_path, notice: "Document approved !"
     else
       redirect_to root_path, alert: "Select atleast any document to approve !"
     end

  end

  def approve_from_doc_view
    doc_id = params[:id].to_i if params[:id]

    if doc_id > 0
      unapproved_document = Document.find(doc_id)
      unapproved_document.approved = true
      unapproved_document.approved_by_user = current_user.id
      unapproved_document.approved_at = Time.zone.now
      unapproved_document.save
      Log.create! description: "<b>#{current_user.email} </b> approved <b>#{unapproved_document.name} </b> at #{unapproved_document.updated_at.strftime '%d-%m-%Y %H:%M:%S'}",
                                    role_id: current_user.roles.ids.first

      user = unapproved_document.user
      # => send notification to the upload user about the approval of document
      if user.mobile?
        send_sms(user.mobile, "#{user.roles.last.name}, Document - #{unapproved_document.name} -approved by- #{User.find(unapproved_document.approved_by_user).email}")
      end

      DocumentsNotifierMailer.notify_uploader(unapproved_document, unapproved_document.user.email).deliver
    end

    redirect_to root_path, notice: "Document Approved !"
  end
end
