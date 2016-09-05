class WelcomeController < ApplicationController
  def index
    @documents = Document.all.order(created_at: :desc)
    @approved_docs = @documents.where("approved = ?", true)
    @unApproved_docs = @documents.where("approved = ?", false)

    puts "}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}"
      puts @documents
    puts "}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}"
  end

  def search
  end
end
