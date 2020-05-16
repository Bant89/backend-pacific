# frozen_string_literal: true

class RemoveUnusedReference < ActiveRecord::Migration[6.0]
  def change
    remove_index :stores, name: 'index_stores_on_users_id'
    remove_column :stores, :users_id
  end
end
