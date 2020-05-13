# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Health', type: :request do
  describe 'GET /health' do
    before { get '/health' }

    it 'should return OK' do
      expect(json).not_to be_empty
      expect(json['api']).to eq('OK')
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end
end
