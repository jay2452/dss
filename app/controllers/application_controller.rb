class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :doc_search
  before_filter :set_cache_buster
  require 'rest-client'
  require "mosto.rb"
  impressionist :unique => [:impressionable_type, :impressionable_id, :session_hash]



  private

  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  def doc_search
    @q = Document.search(params[:q])# || Document.all.order(created_at: :desc)
    # @document = @q.result.includes(:documents).page(params[:page])

  # or use `to_a.uniq` to remove duplicates (can also be done in the view):
    @search_documents = @q.result(distinct: true).includes(:user).order(created_at: :desc)#.where("approved = ?", true)
    docs_searched_ids = []
    @search_documents.each do |doc|
      docs_searched_ids << doc.id
    end

    # => that search should output the results of documents of the groups in the the user has been assigned
    # => check the document-id from the document groups and take the intersection of both and give the result

  end

  def check_role?
    if current_user && ((current_user.has_role? :superAdmin) || (current_user.has_role? :admin))
      puts "#{current_user.email} has role :: superAdmin"
    else
      redirect_to root_path, notice: "you are not authorised !!"
    end
  end

  def send_sms(mob, message_to_send)
    url = "http://sms.gpileportal.co.in/submitsms.jsp?user=#{ENV['DOVE_SMS_GPIL_USER']}&key=#{ENV['DOVE_SMS_GPIL_KEY']}&mobile=+91#{mob}&message=#{message_to_send}&senderid=EPGPIL&accusage=1"
    begin
      RestClient.delay(queue: "send text sms to : #{mob}").get(url)
    rescue Exception => e
      puts "+++++++============="
        p e
      puts "+++++++============="
    end
  end

end
