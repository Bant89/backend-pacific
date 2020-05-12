# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :title
      t.string :description
      t.numeric :price
      t.numeric :amount
      t.string :category
      t.references :store, null: false, foreign_key: true

      t.timestamps
    end
  end
end
