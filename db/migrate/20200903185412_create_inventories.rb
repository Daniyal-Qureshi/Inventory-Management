class CreateInventories < ActiveRecord::Migration[6.0]
  def change
    create_table :inventories do |t|
      t.belongs_to :product, null: false, foreign_key: true
    end
  end
end
