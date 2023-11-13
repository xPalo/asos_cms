class Post < ApplicationRecord
  belongs_to :user, class_name: 'User', foreign_key: 'user_id'
  has_many :comments, class_name: 'Comment', foreign_key: 'post_id'

  validates :title, presence: true
  validates :content, presence: true
  validates :downvotes, presence: true
  validates :upvotes, presence: true

  scope :is_public, -> { where(is_public: true) }

  def comments_count
    comments.count
  end

  def votes
    upvotes - downvotes
  end

  private

  def self.search(search)
    if search
      Post.is_public
          .joins(:user)
          .where("lower(posts.title || posts.content || users.first_name || users.last_name) LIKE ?", "%#{search.downcase}%")
    else
      Post.is_public
    end
  end
end
