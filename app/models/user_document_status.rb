class UserDocumentStatus < ActiveRecord::Base
  belongs_to :user
  belongs_to :document

  validates :user_id, presence: true, uniqueness: { scope: [:document_id] }
  validates :document_id, presence: true
  validates :status, presence: true
end
