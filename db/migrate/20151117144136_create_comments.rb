class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user
      t.references :review
      t.string :title
      t.string :text      
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
