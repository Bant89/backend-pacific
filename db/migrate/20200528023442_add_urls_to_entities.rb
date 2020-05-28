# frozen_string_literal: true

class AddUrlsToEntities < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :avatar_url, :string
    add_column :stores, :image_url, :string
    add_column :products, :images_url, :string, array: true, default: []
  end
end
