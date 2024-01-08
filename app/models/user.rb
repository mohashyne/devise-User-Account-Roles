# class User < ApplicationRecord
#   # Include default devise modules. Others available are:
#   # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
#   devise :database_authenticatable, :registerable,
#          :recoverable, :rememberable, :validatable

#    enum role: [:user, :moderator, :admin]
#    after_initialize :set_default_role, :if => :new_record?
#    def set_default_role
#     self.role ||= :user
#    end

# end

class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  has_many :reservations
  has_many :doctors, through: :reservations

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  enum role: [:user, :admin, :super_admin]

  attr_accessor :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip

  after_initialize :set_default_role, if: :new_record?

  def set_default_role
    self.role ||= :user
  end

  def jwt_payload
    super.merge('role' => role)
  end
end
