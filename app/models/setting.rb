class Setting < ApplicationRecord
  belongs_to :user, class_name: 'User', foreign_key: 'user_id'

  enum default_locale: {
    en: 'en',
    sk: 'sk'
  }
end
