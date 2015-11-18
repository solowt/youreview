class CreateBookworks < ActiveRecord::Migration
  def change
    create_table :bookworks do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.integer :unique_id
      t.string :image_url
      t.string :author
      t.string :title
    end
  end
end
