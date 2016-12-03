class User < ActiveRecord::Base
  # after_create :add_general_role
  rolify
  extend FriendlyId
  friendly_id :email, use: :slugged
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # validates :, presence: true

  has_many :documents, dependent: :destroy
  has_many :user_groups, dependent: :destroy
  has_many :groups, through: :user_groups

  has_many :user_document_statuses, dependent: :destroy

  validates :mobile, length: { maximum: 10 }

#   Since remove_role method will also remove the role from Role table so use a custom function .
  def delete_role(role_symbol,target=nil) # => this function will only remove role of that particular user not the role data from Roles table .
    UsersRole.delete_role self,role_symbol,target
  end

    # def add_general_role
    #
    #   if self.has_role? 'general'
    #     # => do nothing
    #   else
    #     self.add_role "general"
    #   end
    # end
    def soft_delete
      update_attribute(:deleted_at, Time.current)
    end

    # ensure user account is active
    def active_for_authentication?
      super && !deleted_at
    end

    # provide a custom message for a deleted account
    def inactive_message
      !deleted_at ? super : :deleted_account
    end

end
