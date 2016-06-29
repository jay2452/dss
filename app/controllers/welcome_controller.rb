class WelcomeController < ApplicationController
  def index
    @documents = Document.all
    @approved_docs = @documents.where("approved = ?", true)
    @unApproved_docs = @documents.where("approved = ?", false)

    puts "}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}"
      puts @documents
    puts "}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}"
  end

  def search
  end
end
