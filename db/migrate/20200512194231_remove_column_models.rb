# frozen_string_literal: true

class RemoveColumnModels < ActiveRecord::Migration[6.0]
  def up
    change_column_null :stores, :integer_id, true
    remove_column :products, :integer_id
    remove_column :stores, :integer_id
  end

  def down
    add_column :products, :integer_id
    add_column :stores, :integer_id
  end
end
