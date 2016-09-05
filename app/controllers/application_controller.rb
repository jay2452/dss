class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :doc_search
  require "mosto.rb"

  private

  def doc_search
    @q = Document.search(params[:q])
    # @document = @q.result.includes(:documents).page(params[:page])

  # or use `to_a.uniq` to remove duplicates (can also be done in the view):
    @search_documents = @q.result(distinct: true).includes(:user)#.where("approved = ?", true)
  end

  def check_role?

    if current_user && (current_user.has_role? :admin)
      puts "#{current_user.email} has role :: Admin"
    else
      redirect_to root_path, notice: "you are not authorised !!"
    end

  end

  def send_sms_to receiver
    api = MOSTO.new("dev9999", "Demo@123")
      response = api.send(receiver, "DEVLPR",
              "file uploaded : #{@document.name}, see it here : http://localhost:3000#{@document.file.url}")
      puts "==========================="
      puts response
      puts "-==========================="
  end

end
