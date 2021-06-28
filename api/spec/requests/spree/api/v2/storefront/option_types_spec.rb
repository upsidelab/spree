require 'spec_helper'

describe 'Storefront API v2 Option Types spec', type: :request do
  let!(:size) { create(:option_type, :size, filterable: true) }
  let!(:color) { create(:option_type, :color, filterable: false) }

  shared_examples 'returns valid option type resource JSON' do
    it 'returns a valid option type resource JSON response' do
      expect(response.status).to eq(200)

      expect(json_response['data']).to have_type('option_type')
      expect(json_response['data']).to have_relationships(:option_values)

      expect(json_response['data']).to have_attribute(:name)
      expect(json_response['data']).to have_attribute(:presentation)
      expect(json_response['data']).to have_attribute(:position)
    end
  end

  describe 'option_types#index' do
    context 'general' do

      before { get '/api/v2/storefront/option_types' }

      it_behaves_like 'returns 200 HTTP status'

      it 'returns all option types' do
        expect(json_response['data'].size).to eq(Spree::OptionType.count)
        expect(json_response['data'][0]).to have_type('option_type')
        expect(json_response['data'][0]).not_to have_relationships(:option_values)
      end
    end

    context 'with option type filtering' do
      let!(:filterable_url) { '/api/v2/storefront/option_types?filter[filterable]=true' }
      let!(:to_return) { [size] }

      it 'returns option types that are filterable' do
        get filterable_url
        expect(json_response['data'].size).to eq(to_return.size)
        expect(json_response['data'].pluck(:id)).to include(size.id.to_s)
      end
    end
  end

  describe 'option_types#show' do
    context 'by name' do
      before do
        get "/api/v2/storefront/option_tpyes/#{color.name}"
      end

      it_behaves_like 'returns valid option type resource JSON'

      it 'returns option type by name' do
        expect(json_response['data']).to have_id(color.id.to_s)
        expect(json_response['data']).to have_attribute(:name).with_value(color.name)
      end
    end
  end
end
