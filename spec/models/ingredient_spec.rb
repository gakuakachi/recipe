# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ingredient do
  describe 'self.valid_measure_format?' do
    subject { Ingredient.valid_measure_format?(measure_format) }

    context 'when measure format is metric' do
      let!(:measure_format) { 'metric' }
      it { is_expected.to eq true }
    end

    context 'when measure format is imperial' do
      let!(:measure_format) { 'imperial' }
      it { is_expected.to eq true }
    end

    context 'when measure format is invalid format' do
      let!(:measure_format) { 'other' }
      it { is_expected.to eq false }
    end
  end

  describe '#convert_to_imperial' do
    context 'when unit is weight unit' do
      let!(:ingredient) { Ingredient.new(Faker::Food.spice, 1.0, 'kg') }
      it 'converts to imperial weight unit' do
        expect(ingredient.convert_to_imperial).to eq true
        expect(ingredient.unit).to eq 'lb'
      end
    end

    context 'when unit is volume unit' do
      let!(:ingredient) { Ingredient.new(Faker::Food.spice, 10.0, 'ml') }
      it 'converts to imperial weight unit' do
        expect(ingredient.convert_to_imperial).to eq true
        expect(ingredient.unit).to eq 'teaspoon'
      end
    end

    context 'when ingredient is already converted' do
      let!(:ingredient) { Ingredient.new(Faker::Food.spice, 10.0, 'ml') }
      before do
        ingredient.convert_to_imperial
      end
      it 'does not convert again' do
        expect(ingredient.convert_to_imperial).to eq false
      end
    end
  end

  describe '#serialize' do
    let!(:ingredient) do
      Ingredient.new(Faker::Food.spice, rand(0.1..100.0), 'g')
    end
    subject { ingredient.serialize }
    it { is_expected.to include(:name, :quantity, :unit) }
  end
end
