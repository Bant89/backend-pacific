# frozen_string_literal: true

class PasswordsController < ApplicationController
  def forgot
    if params[:email].blank?
      json_response({ error: 'Email not present' }, :unprocessable_entity)
    end

    user = User.find_by(email: email.downcase)

    if user.present? && user.confirmed_at?
      user.generate_password_token!
      UserMailer.new_password(user).deliver_now
      json_response({ status: 'ok' }, :ok)
    else
      json_response({ error: 'Email address not found. Please try again' }, :not_found)
    end
  end

  def reset
    token = params[:token].to_s

    if params[:email].blank?
      json_response({ error: 'Token not present' }, :unprocessable_entity)
    end

    user = User.find_by(reset_password_token: token)

    if user.present? && user.password_token_invalid?
      if user.reset_password!(params[:password])
        json_response({ status: 'ok' }, :ok)
      else
        json_response({ error: user.errors.full_messages }, :unprocessable_entity)
      end
    else
      json_response({ error: 'Link not valid or expired. Try generating a new link.' }, :not_found)
    end
  end

  def update
    unless params[:password].present?
      json_response({ error: 'Password not present' }, :unprocessable_entity)
      return
    end

    if current_user.reset_password(params[:password])
      json_response({ status: 'ok' }, :ok)
    else
      json_response({ errors: current_user.errors.full_messages }, :unprocessable_entity)
    end
  end
end
