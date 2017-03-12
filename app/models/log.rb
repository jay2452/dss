class Log < ActiveRecord::Base
  belongs_to :role
  is_impressionable
end
