class Group < ActiveRecord::Base

  extend FriendlyId
  friendly_id :name, use: :slugged
  is_impressionable

  has_many :document_groups, dependent: :destroy
  has_many :documents, dependent: :destroy#, through: :document_groups

  has_many :user_groups, dependent: :destroy
  has_many :users, through: :user_groups

  belongs_to :user

  belongs_to :upload_user, :foreign_key => "upload_user_id", :class_name => "User"

  validates :name, presence: true, uniqueness: true
  validates :user_id, presence: true
  
end
