# Fills DB with random generated Posts and comments for easier development
# You must have at least one existing user for this to work, more than one ideally
# To run, copy the code below and paste into rails console

def seed(post_count: 100, comment_count: 100)
  user_ids = User.pluck(:id)
  post_count.times do
    Post.create!(
      is_public: true,
      title: Faker::Book.title,
      content: Faker::Quote.famous_last_words,
      user_id: user_ids.sample
    )
  end

  posts_ids = Post.pluck(:id)
  comment_count.times do
    Comment.create!(
      content: Faker::Quote.yoda,
      user_id: user_ids.sample,
      post_id: posts_ids.sample
    )
  end
end

seed
