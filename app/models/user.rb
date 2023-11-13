class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, presence: true, uniqueness: true

  has_one :setting, class_name: 'Setting', foreign_key: 'user_id', dependent: :destroy
  has_many :posts, class_name: 'Post', foreign_key: 'user_id', dependent: :destroy
  has_many :comments, class_name: 'Comment', foreign_key: 'user_id', dependent: :destroy

  after_save :create_setting

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  private

  def create_setting
    return if setting.present?

    Setting.create!(user_id: id)
  end
end
