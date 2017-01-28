class WelcomeController < ApplicationController
  before_action :authenticate_user!, except: :upgrade

  def index
    @users = User.all.order(created_at: :desc)  - User.with_role(:admin) - User.with_role(:superAdmin)

    @groups = Group.limit(4).order(created_at: :desc)
    @documents = Document.where("deleted = ?", false).all.order(created_at: :desc)
    @doc_groups = DocumentGroup.all.order(created_at: :desc)
  end

  def search
  end

  def upgrade

  end
end
