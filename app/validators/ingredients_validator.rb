class IngredientsValidator < ActiveModel::EachValidator
  INGREDIENTS_HASH_SCHEMA = {
    'name' => 'string',
    'quantity' => 'numeric',
    'unit' => 'string'
  }.freeze

  def validate_each(record, attribute, values)
    values.each do |value|
      validator = HashValidator.validate(value, INGREDIENTS_HASH_SCHEMA)
      next if validator.valid? && Measured::Weight.unit_or_alias?(value['unit'])

      record.errors.add(attribute, 'have invalid hash value')
      return
    end
  end
end
