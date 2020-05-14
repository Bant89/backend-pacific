# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_one :store, foreign_key: :created_by

  validates_presence_of :name, :email, :password_digest, :is_admin
end
