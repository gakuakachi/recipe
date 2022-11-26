require 'rails_helper'

describe IngredientsValidator do
  let(:model_class) do
    Struct.new(:ingredients) do
      include ActiveModel::Validations

      validates :ingredients, presence: true, ingredients: true
    end
  end

  describe '#validate' do
    subject { model_class.new(ingredients) }

    context 'when valid ingredients' do
      let!(:ingredients) do
        [
          {
            'name' => Faker::Food.spice,
            'quantity' => rand(0.1..100.0),
            'unit' => 'gram'
          }
        ]
      end
      it { is_expected.to be_valid }
    end

    context 'when invalid ingredients' do
      context 'when unit is invalid' do
        let!(:ingredients) do
          [
            {
              'name' => Faker::Food.spice,
              'quantity' => rand(0.1..100.0),
              'unit' => 'wrong unit'
            }
          ]
        end

        it { is_expected.not_to be_valid }
      end

      context 'when hash keys does not meet schema' do
        let!(:ingredients) do
          [
            {
              'name' => Faker::Food.spice,
              'quantity' => rand(0.1..100.0)
            }
          ]
        end

        it { is_expected.not_to be_valid }
      end
    end
  end
end
