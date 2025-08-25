class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.text :description
      t.monetize :price, null: false
      t.timestamps
    end

    add_index :products, :name, unique: true
  end
end
