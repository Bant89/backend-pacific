# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Products', type: :request do
  let(:user) { create(:user) }
  let!(:store) { create(:store, user_id: user.id) }
  let!(:products) { create_list(:product, 20, store_id: store.id) }
  let(:store_id) { store.id }
  let(:id) { products.first.id }
  let(:headers) { valid_headers }

  # Test suite for GET /stores/:store_id/products
  describe 'GET /stores/:store_id/products' do
    before { get "/stores/#{store_id}/products", params: {}, headers: headers }

    context 'when store exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all store items' do
        expect(json.size).to eq(20)
      end
    end

    context 'when store does not exist' do
      let(:store_id) { '4134134' }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(json['message']).to match(/Couldn't find Store/)
      end
    end
  end

  # Test suite GET /stores/:store_id/products/:id
  describe ' GET /stores/:store_id/products/:id' do
    before { get "/stores/#{store_id}/products/#{id}", params: {}, headers: headers }

    context 'when store product exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the product' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when store item does not exist' do
      let(:id) { '4134134' }
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns not found message' do
        expect(response.body).to match(/Couldn't find Product/)
      end
    end
  end

  # Test suite for POST /store/#{store_id}/products
  describe 'POST /stores/:store_id/products' do
    let(:valid_attributes) { { product: { title: 'Fourwheel LE', price: 350, amount: 10, category: 'toys' } } }

    context 'when request has valid attributes' do
      before { post "/stores/#{store_id}/products", params: valid_attributes.to_json, headers: headers }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when request has invalid attributes' do
      before { post "/stores/#{store_id}/products", params: { product: { amount: nil } }.to_json, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(json['message']).to match(/Validation failed: Amount can't be blank, Title can't be blank, Price can't be blank/)
      end
    end

    context 'when the request store param does not exist' do
      let(:no_attributes) { {} }

      before { post "/stores/#{store_id}/products", params: no_attributes, headers: headers }

      it 'returns status code 406' do
        expect(response).to have_http_status(406)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/param is missing or the value is empty/)
      end
    end
  end

  # Test suite for PUT /store/:store_id/products/:product_id
  describe 'PUT /stores/:store_id/products/:product_id' do
    let(:valid_attributes) { { product: { title: 'Fourwheelszasd' } } }

    before { put "/stores/#{store_id}/products/#{id}", params: valid_attributes.to_json, headers: headers }

    context 'when item exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates the product' do
        updated_product = Product.find(id)
        expect(updated_product.title).to match(/Fourwheelszasd/)
      end
    end

    context 'when the item does not exists' do
      let(:id) { 'asfqeazcvwq' }
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns not found message' do
        expect(json['message']).to match(/Couldn't find Product/)
      end
    end
  end

  # Test suite DELETE /stores/:store_id/products/:product_id
  describe 'DELETE  /stores/:store_id/products/:product_id' do
    before { delete "/stores/#{store_id}/products/#{id}", params: {}, headers: headers }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
