class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, presence: true, uniqueness: true

  has_one :setting, class_name: 'Setting', foreign_key: 'user_id', dependent: :destroy
  has_many :posts, class_name: 'Post', foreign_key: 'user_id', dependent: :destroy
  has_many :comments, class_name: 'Comment', foreign_key: 'user_id', dependent: :destroy
  has_many :votes, class_name: 'Vote', foreign_key: 'user_id', dependent: :destroy

  after_save :create_setting

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  private

  def create_setting
    return if setting.present?

    Setting.create!(user_id: id)
  end

  def self.search(search, current_user = nil)
    if search
      User.where.not(id: current_user&.id).where("lower(first_name || last_name) LIKE ?", "%#{search.downcase}%")
    else
      User.where.not(id: current_user&.id)
    end
  end
end
