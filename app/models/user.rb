class User < ActiveRecord::Base
  enum type: {
    member: 'Member',
    admin: 'Admin'
  }
  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end
  has_many :authentications, :dependent => :destroy
  has_many :stickies
  has_many :tags
  has_many :pages
  paginates_per 20

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes["password"] }
  validates :password, confirmation: true, if: -> { new_record? || changes["password"] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes["password"] }

  validates :email, uniqueness: true

end
