# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_one :store
  has_one_attached :avatar
  validates_presence_of :name, :email, :password_digest
  validates :is_admin, inclusion: [true, false]
end
