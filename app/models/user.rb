# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_one :store
  has_one_attached :avatar
  validates_presence_of :name, :email, :password_digest
  validates :is_admin, inclusion: [true, false]
  validates :email, uniqueness: { case_sensitive: false }

  before_save :downcase_email
  before_create :generate_confirmation_instructions

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

  def update_new_email!(email)
    self.unconfirmed_email = email
    generate_confirmation_instructions
    save
  end

  def self.email_used?(email)
    existing_user = find_by('email = ?', email)

    if existing_user.present?
      true
    else
      waiting_for_confirmation = find_by('unconfirmed_email = ?', email)
      waiting_for_confirmation.present? && waiting_for_confirmation.confirmation_token_valid?
    end
  end

  def generate_instructions
    generate_confirmation_instructions
  end

  def valid_confirmation_token?
    confirmation_token_valid
  end

  def confirmation_success!
    mark_as_confirmed
  end

  private

  def generate_token
    SecureRandom.hex(10)
  end

  def confirmation_token_valid
    (confirmation_sent_at + 15.days) > Time.now.utc
  end

  def mark_as_confirmed
    self.confirmation_token = nil
    self.confirmed_at = Time.now.utc
    save
  end

  def generate_confirmation_instructions
    self.confirmation_token = generate_token
    self.confirmation_sent_at = Time.now.utc
  end

  def downcase_email
    self.email = email.delete(' ').downcase
  end
end
