class WelcomeController < ApplicationController
  def index
    @documents = Document.where("approved = ?", true)

    puts "}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}"
      puts @documents
    puts "}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}"
  end

  def search
  end
end
