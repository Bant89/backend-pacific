# frozen_string_literal: true

class AuthenticationController < ApplicationController
  # skip_before_action :authorize_request, only: :authenticate
  def authenticate
    auth_token = AuthenticateUser.new(auth_params[:email], auth_params[:password]).call
    user = User.find_by(email: auth_params[:email]) unless auth_token == nil?
    response = {
      user: user,
      auth_token: auth_token
    }
    json_response(response, :ok)
  end

  private

  def auth_params
    params.permit(:email, :password)
  end
end
