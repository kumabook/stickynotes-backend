class User < ApplicationRecord
  MEMBER = 'Member'
  ADMIN  = 'Admin'
  enum email_subscription_status: {
         enabled:  0,
         disabled: 1,
       }, _prefix: :email_subscription
  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end
  has_many :authentications, :dependent => :destroy
  has_many :oauth_access_tokens, :foreign_key => :resource_owner_id,
                                  :class_name => 'Doorkeeper::AccessToken'
  has_many :stickies
  has_many :tags
  has_many :pages
  paginates_per 20

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes["password"] }
  validates :password, confirmation: true, if: -> { new_record? || changes["password"] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes["password"] }

  validates :email, uniqueness: true
  validates_format_of :email,:with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/

  def admin?
    type == ADMIN
  end

  def member?
    type == MEMBER
  end
end
