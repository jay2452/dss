class WelcomeController < ApplicationController
  def index
    @documents = Document.all.order(created_at: :desc)
    # @approved_docs = @documents.where("approved = ?", true)
    # @unApproved_docs = @documents.where("approved = ?", false)
    #
    # puts "}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}"
    #   puts @documents
    # puts "}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}"

    @user_groups = current_user.groups

    arr = []
    #   fetch all the id of documents from groups in which the user belongs to.

    if @user_groups != nil
      @user_groups.each do |group|
        group.documents.each do |doc|
          arr << doc.id
        end
      end
      # 
      # puts "++++++++++++++"
      #   p arr
      # puts "++++++++++++++"
    end

    @recent_docs = Document.where("id IN (?)", arr).order(created_at: :desc)



  end

  def search
  end
end
