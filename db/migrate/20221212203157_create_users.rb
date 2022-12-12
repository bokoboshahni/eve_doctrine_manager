class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.integer :alliance_id
      t.string :api_key
      t.integer :corporation_id
      t.boolean :admin
      t.boolean :manager
      t.integer :character_id, null: false, index: { unique: true }
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.text :name, null: false
      t.integer :sign_in_count
      t.timestamps null: false
    end
  end
end
