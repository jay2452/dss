module Admin
  class LogsController < ApplicationController

    before_action :authenticate_user!
    load_and_authorize_resource

    def index
      @logs = Log.paginate(:page => params[:page], :per_page => 10).order(created_at: :desc)
    end

    def viewUser
      @viewUserLogs = Role.find_by_name(:viewUser).logs.paginate(:page => params[:page], :per_page => 10).order(created_at: :desc)
    end

    def uploadUser
      @uploadUserLogs = Role.find_by_name(:uploadUser).logs.paginate(:page => params[:page], :per_page => 10).order(created_at: :desc)
    end

    def adminUser
      @adminLogs = Role.find_by_name(:admin).logs.paginate(:page => params[:page], :per_page => 10).order(created_at: :desc)
    end
  end

end
