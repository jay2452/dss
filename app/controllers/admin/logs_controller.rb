module Admin
  require 'log_pdf'
  class LogsController < ApplicationController

    before_action :authenticate_user!
    load_and_authorize_resource

    def index
      @logs = Log.paginate(:page => params[:page], :per_page => 10).order(created_at: :desc)
      respond_to do |format|
        format.html
        format.js
        format.pdf do
          pdf = LogPdf.new(Log.all, "ALL",view_context)
          send_data pdf.render, filename: "all_Logs.pdf", type: "application/pdf", disposition: :inline
        end
      end
    end

    def viewUser
      logs = Role.find_by_name(:viewUser).logs
      @viewUserLogs = logs.paginate(:page => params[:page], :per_page => 10).order(created_at: :desc)
      respond_to do |format|
        format.html
        format.js
        format.pdf do
          pdf = LogPdf.new(logs, "VIEW USER",view_context)
          send_data pdf.render, filename: "view_user_logs.pdf", type: "application/pdf", disposition: :inline
        end
      end
    end

    def uploadUser
      logs =  Role.find_by_name(:uploadUser).logs
      @uploadUserLogs = logs.paginate(:page => params[:page], :per_page => 10).order(created_at: :desc)
      respond_to do |format|
        format.html
        format.js
        format.pdf do
          pdf = LogPdf.new(logs, "UPLOAD USER",view_context)
          send_data pdf.render, filename: "upload_user_logs.pdf", type: "application/pdf", disposition: :inline
        end
      end
    end

    def adminUser
      logs = Role.find_by_name(:admin).logs
      @adminLogs = logs.paginate(:page => params[:page], :per_page => 10).order(created_at: :desc)
      respond_to do |format|
        format.html
        format.js
        format.pdf do
          pdf = LogPdf.new(logs, "ADMIN",view_context)
          send_data pdf.render, filename: "admin_logs.pdf", type: "application/pdf", disposition: :inline
        end
      end
    end
  end

end
