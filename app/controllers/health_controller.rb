# frozen_string_literal: true

class HealthController < ApplicationController
  skip_before_action :authorize_request, only: :health
  def health
    render json: { api: 'OK' }, status: :ok
  end
end
