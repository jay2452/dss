class DocumentCategory < ActiveRecord::Base
  has_many :documents
  is_impressionable
end
