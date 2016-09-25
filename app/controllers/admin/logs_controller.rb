module Admin
  class LogsController < ApplicationController

    before_action :authenticate_user!
    before_action :check_role?
    load_and_authorize_resource

    def index
      @logs = Log.paginate(:page => params[:page], :per_page => 10).order(created_at: :desc)
    end
  end

end
