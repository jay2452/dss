class Document < ActiveRecord::Base
  belongs_to :user
  belongs_to :document_category

  has_attached_file :file
	validates_attachment :file
	validates_attachment_content_type :file, content_type: %w(application/pdf)
end
