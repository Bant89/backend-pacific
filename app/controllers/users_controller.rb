# frozen_string_literal: true

# User controller, responsabilities: CRUD, email and user confirmation
class UsersController < ApplicationController
  # skip_before_action :authorize_request, only: %i[create confirm]
  before_action :set_user, only: %i[show update email_update]
  before_action :validate_email_update, only: :email_update
  def create
    user = User.create!(user_params)
    return unless user.save

    # user.generate_instructions
    # user.save
    # UserMailer.confirm_email(user).deliver_now
    # auth_token = AuthenticateUser.new(user.email, user.password).call
    response = {
      message: Message.account_created,
      user: user
      # auth_token: auth_token
    }
    json_response(response, :ok)
  end

  # PUT /user/:id
  def update
    @user.update(user_params)
  end

  # GET /user/:id
  def show
    json_response(@user)
  end

  # POST /users/email_update
  def email_update
    if @user[:user].update_new_email!(@new_email)
      UserMailer.confirm_email(@user).deliver_now
      json_response({ status: Message.confirmation_email }, :ok)
    else
      request_error = @user.errors.values.flatten.compact
      json_response({ errors: request_error }, :bad_request)
    end
  end

  # POST /users/email_update_confirmed
  def email_update_confirmed
    token = params[:token].to_s
    user = User.find_by(confirmation_token: token)
    if !user || !user.confirmation_token_valid?
      json_response({ error: Message.invalid_token }, :not_found)
    else
      user.update_new_email!
      json_response({ status: 'Email updated successfully' }, :ok)
    end
  end

  def confirm
    token = params[:token].to_s

    user = User.find_by(confirmation_token: token)

    if user.present? && user.valid_confirmation_token?
      user.confirmation_success!
      UserMailer.welcome_email(user).deliver_now
      json_response({ status: 'User confirmed successfully' }, :ok)
    else
      json_response({ status: Message.invalid_token }, :not_found)
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

    if @new_email == @current_user[:user].email
      json_response({ status: Message.current_new_email }, :bad_request)
    end

    return unless User.email_used?(@new_email)

    json_response({ error: 'Email already in use.' }, :unprocessable_entity)
  end
end
