class AddForeignKeyToStore < ActiveRecord::Migration[6.0]
  def change
    add_reference :stores, :user, foreign_key: true, type: :uuid
  end
end
