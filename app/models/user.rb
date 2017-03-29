class User < ActiveRecord::Base
  rolify
  extend FriendlyId
  friendly_id :email, use: :slugged
  is_impressionable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable,  and :omniauthable
  devise :database_authenticatable, :registerable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :documents, dependent: :destroy
  has_many :user_groups, dependent: :destroy
  has_many :groups, through: :user_groups

  has_many :user_document_statuses, dependent: :destroy

  validates :mobile, length: { is: 10 }, uniqueness: true

  has_many :documents_approved, foreign_key: "approved_by_user", class_name: "Document"

#   Since remove_role method will also remove the role from Role table so use a custom function .
    def delete_role(role_symbol,target=nil) # => this function will only remove role of that particular user not the role data from Roles table .
      UsersRole.delete_role self,role_symbol,target
    end

    def soft_delete
      update_attribute(:deleted_at, Time.current)
      update_attribute(:is_active, false)
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
