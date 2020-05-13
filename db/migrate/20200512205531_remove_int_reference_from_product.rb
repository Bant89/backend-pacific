# frozen_string_literal: true

class RemoveIntReferenceFromProduct < ActiveRecord::Migration[6.0]
  def up
    add_column :products, :store_uuid, :uuid

    change_column_null :products, :store_uuid, false

    remove_column :products, :store_id
    rename_column :products, :store_uuid, :store_id

    add_index :products, :store_id

    execute <<-SQL
      UPDATE products SET store_id = stores.id
      FROM stores WHERE products.store_id = stores.id
    SQL

    add_foreign_key :products, :stores

    add_index :products, :created_at
    add_index :stores, :created_at
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
