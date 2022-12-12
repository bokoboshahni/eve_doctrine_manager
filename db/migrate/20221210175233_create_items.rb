# frozen_string_literal: true

class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :item_categories do |t|
      t.text :name, null: false
      t.boolean :published, null: false
      t.timestamps null: false
    end

    create_table :item_groups do |t|
      t.references :category, null: false

      t.text :name, null: false
      t.boolean :published, null: false
      t.timestamps null: false
    end

    create_table :items do |t|
      t.references :group, null: false

      t.string :name, null: false
      t.boolean :published, null: false
      t.string :slot
      t.timestamps null: false
    end
  end
end
