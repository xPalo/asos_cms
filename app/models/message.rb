class Message < ApplicationRecord
  belongs_to :receiver, class_name: "User", foreign_key: "receiver_id"
  belongs_to :sender, class_name: "User", foreign_key: "sender_id"
  scope :unread, -> { where read: false }

  validates :content, presence: true, length: { maximum: 500 }
  validates :sender_id, presence: true
  validates :receiver_id, presence: true
end
