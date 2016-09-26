class WelcomeController < ApplicationController
  before_action :authenticate_user!
  def index
    @groups = Group.limit(4).order(created_at: :desc)
    @documents = Document.all.order(created_at: :desc)
    @doc_groups = DocumentGroup.all.order(created_at: :desc)
    # @approved_docs = @documents.where("approved = ?", true)
    # @unApproved_docs = @documents.where("approved = ?", false)


    @user_groups = current_user.groups#.where("group_id != ?", Group.first.id) # => - Group.first # => first group will contan the list of all users

    # @user_groups_1 = current_user.groups

    arr = []
    #   fetch all the id of documents from groups in which the user belongs to.

    if !@user_groups.empty?
      @user_groups.each do |group|
        group.documents.each do |doc| # => it is fetching records from DocumentGroup table
          arr << doc.id
        end
      end
      #
      # puts "++++++++++++++"
      #   p arr
      # puts "++++++++++++++"
    end

    # current_user.documents.each do |doc|
    #   arr << doc.id
    # end

    # arr.uniq!

    @recent_docs = DocumentGroup.where("document_id IN (?)", arr).order(created_at: :desc)


    #  fetch documents from Document Groups table


  end

  def search
  end
end
