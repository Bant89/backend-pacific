# frozen_string_literal: true

class Store < ApplicationRecord
  self.implicit_order_column = 'created_at'
  has_many :products, dependent: :destroy
  belongs_to :user
  validates_presence_of :title

  before_create do
    self.id = SecureRandom.uuid
  end
end
