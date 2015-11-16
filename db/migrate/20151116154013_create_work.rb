class CreateWork < ActiveRecord::Migration
  def change
    create_table :works do |t|
      t.json 'api-data'
      t.string :title
      t.datetime :created_at
      t.datetime :updated_at
      t.string :medium
    end
  end
end
