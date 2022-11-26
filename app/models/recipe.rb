# frozen_string_literal: true

class Recipe < ApplicationRecord
  include UuidAutoGenerate
  belongs_to :user
  has_many :rates

  serialize :steps, JSON
  serialize :ingredients, JSON

  validates :description, presence: true
  validates :steps, presence: true
  validates :ingredients, presence: true, ingredients: true
end
