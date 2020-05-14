# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Stores', type: :request do
  let(:user) { create(:user) }
  let!(:stores) { create_list(:store, 10) }
  let(:store_id) { stores.first.id }
  let(:headers) { valid_headers }
  # Test suite for GET
  describe 'GET /stores' do
    before { get '/stores', params: {}, headers: headers }

    it 'returns stores' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /stores/:id' do
    before { get "/stores/#{store_id}", params: {}, headers: headers }

    context 'when the record exists' do
      it 'returns the store' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(store_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:store_id) { 'asdads300' }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Store/)
      end
    end
  end

  # Test suite for POST
  describe 'POST /stores' do
    let(:valid_attributes) { { store: { title: 'Pepe Ganga', created_by: user.id.to_s } } }

    context 'when the request is valid' do
      before { post '/stores', params: valid_attributes, headers: headers }

      it 'creates a store' do
        expect(json['title']).to eq('Pepe Ganga')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request store params are invalid' do
      let(:invalid_attributes) { { store: { created_by: user.id.to_s } } }

      before { post '/stores', params: invalid_attributes, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Title can't be blank/)
      end
    end

    context 'when the request store param does not exist' do
      let(:no_attributes) { {} }

      before { post '/stores', params: no_attributes, headers: headers }

      it 'returns status code 406' do
        expect(response).to have_http_status(406)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/param is missing or the value is empty/)
      end
    end
  end

  # Test suite for PUT
  describe 'PUT /stores/:id' do
    let(:valid_attributes) { { store: { title: 'Mundo del Juguete' } } }

    context 'when the record exists' do
      before { put "/stores/#{store_id}", params: valid_attributes, headers: headers }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  # Test suite for DELETE
  describe 'DELETE /stores/:id' do
    before { delete "/stores/#{store_id}", params: {}, headers: headers }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
