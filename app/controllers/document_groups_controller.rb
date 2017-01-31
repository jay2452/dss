class DocumentGroupsController < ApplicationController
  before_action :authenticate_user!

  def index
    @user_groups = current_user.groups.where("disabled = ?", false)#.where("group_id != ?", Group.first.id) # => - Group.first # => first group will contan the list of all users
    # @user_groups_1 = current_user.groups
    arr = []
    #   fetch all the id of documents from groups in which the user belongs to.
    if !@user_groups.empty?
      @user_groups.each do |group|
        group.documents.where("documents.deleted = ?", false).each do |doc| # => it is fetching records from DocumentGroup table
          arr << doc.id
        end
      end
    end
    # arr.uniq!
    # => recent docs only for the viewuser purpose to veiw the files uploaded recently in his project/group
    @document_groups = DocumentGroup.where("document_id IN (?)", arr).paginate(:page => params[:page], :per_page => 10).order(created_at: :desc)
  end

  def project
    # @doc_group = DocumentGroup.find params[:id]
    @group = Group.find(params[:project])
    doc_arr = @group.documents.where("deleted = ?", false).ids # => store the ids of documents in doc_arr and use it in DocumentGroup table
    # => Document group table store the details of the documents which are sent
    # => to retrieve the ssent document in a project, use DocumentGroup table

    @document_groups = DocumentGroup.where("document_id IN (?)", doc_arr).order(created_at: :desc)
    # => it can contain many duplicate rows , but that rows indicate, the number of times the document being sent
    # => note: the created_at columns will be different 
  end

end
