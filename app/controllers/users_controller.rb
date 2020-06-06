# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :authorize_request, only: %i[create confirm]
  before_action :set_user, only: %i[show update email_update]
  before_action :validate_email_update, only: :email_update
  def create
    user = User.create!(user_params)
    if user.save
      # Send confirmation email
      UserMailer.welcome_email(user).deliver_now
      auth_token = AuthenticateUser.new(user.email, user.password).call
      response = {
        message: Message.account_created,
        auth_token: auth_token
      }
      json_response(response, :created)
    end
  end

  # PUT /user/:id
  def update
    @user.update(user_params)
  end

  # POST /users/email_update
  def email_update; end

  # GET /user/:id
  def show
    json_response(@user)
  end

  def email_update
    if @user.update_new_email!(@new_email)
      json_response({ status: 'Email Confirmation has been sent to your new Email.' }, :ok)
    else
      json_response({ errors: @user.errors.values.flatten.compact }, :bad_request)
    end
  end

  def confirm
    token = params[:token].to_s

    user = User.find_by(confirmation_token: token)

    if user.present? && user.confirmation_token_valid?
      user.mark_as_confirmed!
      json_response({ status: 'User confirmed successfully' }, :ok)
    else
      json_response({ status: 'Invalid token' }, :not_found)
    end
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
      :token
    )
  end

  def set_user
    @user = @current_user unless user_params[:id].present?
    @user = User.find(user_params[:id])
  end

  def validate_email_update
    @new_email = params[:email].to_s.downcase

    if @new_email.blank?
      json_response({ status: 'Email cannot be blank' }, :bad_request)
    end

    if @new_email == @current_user.email
      json_response({ status: 'Current Email and New Email cannot be the same' }, :bad_request)
    end

    if User.email_used?(@new_email)
      json_response({ error: 'Email is already in use.' }, :unprocessable_entity)
    end
  end
end
