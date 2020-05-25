# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:user) { build(:user) }
  let(:headers) { valid_headers.except('Authorization') }
  let(:valid_attributes) do
    attributes_for(:user, password_confirmation: user.password)
  end
  let(:test_attributes) do
    { user: valid_attributes }
  end

  describe 'POST /signup' do
    context 'when valid request' do
      before { post '/signup', params: test_attributes.to_json, headers: headers }

      it 'creates a new user' do
        expect(response).to have_http_status(201)
      end

      it 'returns a success message' do
        expect(json['message']).to match(/Account created successfully/)
      end

      it 'returns an authentication token' do
        expect(json['auth_token']).not_to be_nil
      end
    end

    context 'when invalid request' do
      before { post '/signup', params: { user: {} }.to_json, headers: headers }

      it 'does not create a new user' do
        expect(response).to have_http_status(406)
      end

      it 'returns failure message' do
        expect(json['message'])
          .to match(/param is missing or the value is empty: user/)
      end
    end
  end
end
