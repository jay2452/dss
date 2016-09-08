class Document < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :document_groups
  has_many :groups, through: :document_groups

  belongs_to :user
  belongs_to :document_category

  validates :name, presence: true
  validates :document_category_id, presence: true
  validates :user_id, presence: true

  has_attached_file :file
	validates_attachment :file, size: { in: 0..100.megabytes }
	validates_attachment_content_type :file, content_type: %w(application/pdf)
end
