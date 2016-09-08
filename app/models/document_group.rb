class DocumentGroup < ActiveRecord::Base
  belongs_to :document
  belongs_to :group

  validates :document_id, presence: true
  validates :group_id, presence: true
end
