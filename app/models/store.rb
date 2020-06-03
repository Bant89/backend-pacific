# frozen_string_literal: true

class Store < ApplicationRecord
  self.implicit_order_column = 'created_at'
  has_many :products, dependent: :destroy
  has_one_attached :image
  belongs_to :user
  validates_presence_of :title
  validates :title, uniqueness: { case_sensitive: false }

  before_create do
    self.id = SecureRandom.uuid
  end
end
