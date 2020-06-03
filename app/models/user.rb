# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_one :store
  has_one_attached :avatar
  validates_presence_of :name, :email, :password_digest
  validates :is_admin, inclusion: [true, false]
  validates :email, uniqueness: { case_sensitive: false }

  def generate_password_token!
    self.reset_password_token = generate_token
    self.reset_password_sent_at = Time.now.utc
    save!
  end

  def password_token_valid?
    (reset_password_sent_at + 2.hours) > Time.now.utc
  end

  def reset_password!(password)
    self.reset_password_token = nil
    self.password = password
    save!
  end

  private

  def generate_token
    SecureRandom.hex(10)
  end
end
