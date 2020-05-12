class CreateStores < ActiveRecord::Migration[6.0]
  def change
    create_table :stores do |t|
      t.string :title
      t.string :description
      t.string :created_by
      t.string :image
      t.string :category

      t.timestamps
    end
  end
end
