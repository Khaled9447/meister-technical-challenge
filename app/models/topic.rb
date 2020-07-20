class Topic < ApplicationRecord
  # Assocations
  belongs_to :parent, class_name: :Topic, foreign_key: :parent_id, optional: true
  has_many :children, class_name: :Topic, foreign_key: :parent_id

  # Validations
  validates_presence_of :title, :level
  validates_numericality_of :level, only_integer: true, greater_than_or_equal_to: 0
end
