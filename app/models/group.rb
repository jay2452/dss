class Group < ActiveRecord::Base

  has_many :document_groups
  has_many :documents, through: :document_groups

  has_many :user_groups, dependent: :destroy
  has_many :users, through: :user_groups

  belongs_to :user

end
