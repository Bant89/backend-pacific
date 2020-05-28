# frozen_string_literal: true

class StoreSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :category, :image_url

  has_many :products
  belongs_to :user
end
