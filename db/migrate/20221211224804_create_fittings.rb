class CreateFittings < ActiveRecord::Migration[7.0]
  def change
    create_table :fittings do |t|
      t.references :container, index: false

      t.text :description
      t.text :fitting_name, null: false
      t.boolean :published
      t.timestamps null: false

      t.index %i[container_id fitting_name], unique: true
    end

    create_table :fitting_items do |t|
      t.references :fitting, null: false
      t.references :item, null: false
      t.references :charge

      t.string :location
      t.boolean :offline
      t.integer :position, null: false
      t.integer :quantity
      t.string  :section
      t.timestamps null: false
    end
  end
end
