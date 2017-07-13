class Category < ApplicationRecord
  has_many :chats
  extend FriendlyId
  friendly_id :name, use: :slugged
end
