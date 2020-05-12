# frozen_string_literal: true

class Store < ApplicationRecord
  self.implicit_order_column = 'created_at'
  has_many :products, dependent: :destroy
  validates_presence_of :created_by, :title
end
