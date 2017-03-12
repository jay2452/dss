class DocumentGroup < ActiveRecord::Base
  belongs_to :document
  belongs_to :group

  is_impressionable

  validates :document_id, presence: true
  validates :group_id, presence: true
  validates :user_id, presence: true


end
