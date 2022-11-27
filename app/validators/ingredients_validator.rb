# frozen_string_literal: true

class IngredientsValidator < ActiveModel::EachValidator
  INGREDIENTS_HASH_SCHEMA = {
    'name' => 'string',
    'quantity' => 'numeric',
    'unit' => 'string'
  }.freeze

  def validate_each(record, attribute, values)
    values.each do |value|
      validator = HashValidator.validate(value, INGREDIENTS_HASH_SCHEMA)
      next if validator.valid? && valid_unit?(value['unit'])

      record.errors.add(attribute, 'have invalid hash value')
      return
    end
  end

  private

  def valid_unit?(unit)
    Ingredient::METRIC_WEIGHT_UNITS.include?(unit) || Ingredient::METRIC_VOLUME_UNITS.include?(unit)
  end
end
