class CreateBookreviews < ActiveRecord::Migration
  def change
    create_table :bookreviews do |t|
      t.references :user
      t.references :work
      t.string :phto_url
      t.string :title
      t.string :text
      t.string :category
      t.string :name
      t.integer :score
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
