# frozen_string_literal: true

class Product < ApplicationRecord
  self.implicit_order_column = 'created_at'
  belongs_to :store
  has_many_attached :images
  validates_presence_of :amount, :title, :price

  before_create do
    self.id = SecureRandom.uuid
  end
end
