class User < ActiveRecord::Base
  # after_create :add_general_role
  rolify
  extend FriendlyId
  friendly_id :email, use: :slugged
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :documents, dependent: :destroy
  has_many :user_groups, dependent: :destroy
  has_many :groups, through: :user_groups


  def delete_role(role_symbol,target=nil)
    UsersRole.delete_role self,role_symbol,target
  end

  private
    def add_general_role

      if self.has_role? 'general'
        # => do nothing
      else
        self.add_role "general"
      end
    end

end
