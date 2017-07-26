class IntentResponse < ApplicationRecord
  has_many :intent_affected_contexts
  has_many :intent_parameters
  belongs_to :intent

  accepts_nested_attributes_for :intent_affected_contexts, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :intent_parameters, reject_if: :all_blank, allow_destroy: true
end
