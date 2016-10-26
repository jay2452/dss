class WelcomeController < ApplicationController
  before_action :authenticate_user!
  def index
    @users = User.all.order(created_at: :desc)  - User.with_role(:admin) - User.with_role(:superAdmin)

    @groups = Group.limit(4).order(created_at: :desc)
    @documents = Document.all.order(created_at: :desc)
    @doc_groups = DocumentGroup.all.order(created_at: :desc)
  end

  def search
  end
end
