# frozen_string_literal: true

class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :item_categories do |t|
      t.text :name, null: false
      t.boolean :published, null: false
      t.timestamps null: false
    end

    create_table :item_groups do |t|
      t.references :category,
                   null: false,
                   index: { name: :item_groups_category_id_idx },
                   foreign_key: { name: :item_groups_category_id_fkey, to_table: :item_categories }

      t.text :name, null: false
      t.boolean :published, null: false
      t.timestamps null: false
    end

    create_table :items do |t|
      t.references :group,
                   null: false,
                   index: { name: :items_group_id_idx },
                   foreign_key: { name: :item_group_id_fkey, to_table: :item_groups }

      t.text :name, null: false
      t.text :aliases, array: true
      t.boolean :published, null: false
      t.timestamps null: false
    end
  end
end
