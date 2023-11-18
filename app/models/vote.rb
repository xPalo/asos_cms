class Vote < ApplicationRecord
  belongs_to :user, class_name: 'User', foreign_key: 'user_id'
  belongs_to :post, class_name: 'Post', foreign_key: 'post_id'

  validates :vote_type, presence: true, inclusion: ['upvote', 'downvote']

  enum vote_type: {
    upvote: 'upvote',
    downvote: 'downvote'
  }
end
