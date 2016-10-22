class DocumentGroupsController < ApplicationController
  before_action :authenticate_user!

  def index
    @user_groups = current_user.groups#.where("group_id != ?", Group.first.id) # => - Group.first # => first group will contan the list of all users
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
    @document_groups = DocumentGroup.where("document_id IN (?)", arr).paginate(:page => params[:page], :per_page => 5).order(created_at: :desc)
  end

end
