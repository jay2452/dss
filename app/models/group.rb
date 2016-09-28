class Group < ActiveRecord::Base

  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :document_groups, dependent: :destroy
  has_many :documents, dependent: :destroy#, through: :document_groups

  has_many :user_groups, dependent: :destroy
  has_many :users, through: :user_groups

  belongs_to :user

end
