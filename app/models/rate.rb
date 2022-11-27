# frozen_string_literal: true

class Rate < ApplicationRecord
  include UuidAutoGenerate
  belongs_to :user
  belongs_to :recipe

  validates :value, numericality: { in: 0.0..5.0 }
  validates_uniqueness_of :user, scope: :recipe
end
