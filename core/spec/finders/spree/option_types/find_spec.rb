require 'spec_helper'

module Spree
  RSpec.describe OptionTypes::Find do
    let(:finder) { described_class.new }

    let!(:size) { create(:option_type, :size, filterable: false) }
    let!(:color) { create(:option_type, :color, filterable: true) }

    describe '#execute' do
      subject(:result) { finder.execute }

      it 'finds Option Types' do
        expect(result).to contain_exactly(size, color)
      end

      context 'when given a predefined scope' do
        let(:finder) { described_class.new(scope: scope) }
        let(:scope) { OptionType.where(id: [size.id]) }

        it 'finds available Option Types with respect to a predefined scope' do
          expect(result).to contain_exactly(size)
        end
      end

      context 'when given a name filter' do
        let(:finder) { described_class.new(params: { filter: { name: 'color' } }) }

        it 'finds only Option Types matching name criteria' do
          expect(result).to contain_exactly(color)
        end
      end

      context 'when given filterable filter' do
        let(:finder) { described_class.new(params: { filter: { filterable: 'true' } }) }

        it 'finds only Option Types that are filterable' do
          expect(result).to contain_exactly(size)
        end
      end
    end
  end
end
