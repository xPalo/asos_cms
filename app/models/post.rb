class Post < ApplicationRecord
  belongs_to :user, class_name: 'User', foreign_key: 'user_id'
  has_many :comments, class_name: 'Comment', foreign_key: 'post_id', dependent: :destroy
  has_many :votes, class_name: 'Vote', foreign_key: 'post_id', dependent: :destroy

  validates :title, presence: true
  validates :content, presence: true

  scope :is_public, -> { where(is_public: true) }

  def comments_count
    comments.count
  end

  def upvotes
    self.votes.where(vote_type: 'upvote').count
  end

  def downvotes
    self.votes.where(vote_type: 'downvote').count
  end

  def votes_count
    upvotes - downvotes
  end

  private

  def self.search(search)
    if search
      Post.is_public
          .joins(:user)
          .where("lower(posts.title || posts.content || users.first_name || users.last_name || users.email) LIKE ?", "%#{search.downcase}%")
    else
      Post.is_public
    end
  end
end
