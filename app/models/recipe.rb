class Recipe < ApplicationRecord
  include UuidAutoGenerate
  belongs_to :user
  has_many :rates

  serialize :steps, Array
  serialize :ingredients, Array

  validates :description, presence: true
  validates :steps, presence: true
  validates :ingredients, presence: true
end
