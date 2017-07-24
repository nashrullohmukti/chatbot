class Entity < ApplicationRecord
  has_many :entries, inverse_of: :entity, dependent: :destroy
  accepts_nested_attributes_for :entries, reject_if: :all_blank, allow_destroy: true
end
