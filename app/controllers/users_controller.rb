# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :authorize_request, only: %i[create]
  before_action :set_user, only: %i[show update]
  def create
    user = User.create!(user_params)
    auth_token = AuthenticateUser.new(user.email, user.password).call
    response = {
      message: Message.account_created,
      auth_token: auth_token
    }
    json_response(response, :created)
  end

  # PUT /user/:id
  def update
    @user.update(user_params)
  end

  # GET /user/:id
  def show
    json_response(@user)
  end

  private

  def user_params
    params.permit(
      :id,
      :name,
      :email,
      :password,
      :password_confirmation,
      :is_admin,
      :avatar
    )
  end

  def set_user
    @user = @current_user unless user_params[:id].present?
    @user = User.find(user_params[:id])
  end
end
