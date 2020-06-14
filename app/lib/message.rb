# frozen_string_literal: true

# Class to store usual return messages for json_response
class Message
  def self.not_found(record = 'record')
    "Sorry, #{record} not found."
  end

  def self.invalid_credentials
    'Invalid credentials'
  end

  def self.invalid_token
    'Invalid token. Try requesting a new one'
  end

  def self.missing_token
    'Missing token'
  end

  def self.unauthorized
    'Unauthorized request'
  end

  def self.account_created
    'Account created successfully'
  end

  def self.account_not_created
    'Account could not be created'
  end

  def self.confirmation_email
    'Confirmation token has been sent to email'
  end

  def self.current_new_email
    'Current Email and New Email cannot be the same'
  end

  def self.expired_token
    'Sorry, your token has expired. Please login to continue'
  end
end
