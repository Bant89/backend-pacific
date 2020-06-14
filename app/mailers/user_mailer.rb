# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Pacific Stores')
  end

  def new_password(user)
    @user = user
    mail(to: @user.email, subject: 'New Pacific Stores password')
  end

  def confirm_email(user)
    @user = user
    mail(to: @user.email, subject: 'Pacific Stores confirmation email')
  end
end
