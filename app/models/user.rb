class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, presence: true, uniqueness: true

  def full_name
    "#{self.first_name} #{self.last_name}"
  end
end
