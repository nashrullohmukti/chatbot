class Category < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :chats
  has_many :intent_user_says
  has_many :intent_responses
  accepts_nested_attributes_for :intent_user_says, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :intent_responses, reject_if: :all_blank, allow_destroy: true
end
