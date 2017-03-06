class Document < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :user_document_statuses, dependent: :destroy

  has_many :document_groups, dependent: :destroy
  has_one :group, through: :document_groups

  belongs_to :group

  has_many :user_document_statuses

  belongs_to :user
  belongs_to :document_category
  
  belongs_to :approver, :foreign_key => "approved_by_user", :class_name => "User"

  validates :name, presence: true
  # validates :document_category_id, presence: true
  validates :user_id, presence: true
  validates :group_id, presence: true

  has_attached_file :file
	validates_attachment :file, size: { in: 0..100.megabytes }, presence: true
	validates_attachment_content_type :file, content_type: %w(application/pdf image/jpg image/jpeg image/png)
end
