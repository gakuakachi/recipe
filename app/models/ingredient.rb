# frozen_string_literal: true

class Ingredient
  include ActiveModel::Model
  include ActiveModel::Serialization

  MEASURE_METRIC = 'metric'
  MEASURE_IMPERIAL = 'imperial'

  IMPERIAL_WEIGHT_UNITS = %w[oz lb].freeze
  IMPERIAL_VOLUME_UNITS = ['teaspoon', 'tablespoon', 'oz fl', 'cup', 'quart', 'gallon'].freeze
  METRIC_WEIGHT_UNITS = %w[g mg kg].freeze
  METRIC_VOLUME_UNITS = %w[ml l].freeze

  def self.valid_measure_format?(measure_format)
    [MEASURE_METRIC, MEASURE_IMPERIAL].include?(measure_format)
  end

  attr_reader :name, :quantity, :unit

  def initialize(name, quantity, unit)
    @name = name
    @quantity = quantity
    @unit = unit
    @measure_format = MEASURE_METRIC
  end

  def convert_to_imperial
    return false if @measure_format == MEASURE_IMPERIAL

    base_measurement = Unitwise(@quantity, @unit)
    current_measurement = base_measurement.convert_to(imperial_units.first)
    imperial_units.each do |unit|
      converted_measurement = base_measurement.convert_to(unit)
      break if converted_measurement.value < 1

      current_measurement = converted_measurement
    end
    @quantity = current_measurement.value.to_f
    @unit = current_measurement.unit.to_s
    @measure_format = MEASURE_IMPERIAL
    true
  end

  def serialize
    IngredientSerializer.new(self).to_h
  end

  private

  def imperial_units
    return IMPERIAL_WEIGHT_UNITS if METRIC_WEIGHT_UNITS.include?(@unit)

    IMPERIAL_VOLUME_UNITS
  end
end
