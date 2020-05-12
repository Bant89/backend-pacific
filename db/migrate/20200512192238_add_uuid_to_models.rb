# frozen_string_literal: true

class AddUuidToModels < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :uuid, :uuid, default: 'gen_random_uuid()', null: false
    rename_column :products, :id, :integer_id
    rename_column :products, :uuid, :id
    execute 'ALTER TABLE products drop constraint products_pkey CASCADE;'
    execute 'ALTER TABLE products ADD PRIMARY KEY  (id);'
    execute 'DROP SEQUENCE IF EXISTS products_id_seq CASCADE'
    execute 'ALTER TABLE ONLY products ALTER COLUMN store_id DROP DEFAULT;'
    change_column_null :products, :integer_id, true

    add_column :stores, :uuid, :uuid, default: 'gen_random_uuid()', null: false
    rename_column :stores, :id, :integer_id
    rename_column :stores, :uuid, :id
    execute 'ALTER TABLE stores drop constraint stores_pkey CASCADE;'
    execute 'ALTER TABLE stores ADD PRIMARY KEY  (id);'
    execute 'DROP SEQUENCE IF EXISTS stores_id_seq CASCADE'
    # execute 'ALTER TABLE ONLY stores ALTER COLUMN store_id DROP DEFAULT;'
    # change_column_null :stores, :integer_id, true
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
