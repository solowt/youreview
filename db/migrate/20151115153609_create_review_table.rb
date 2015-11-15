class CreateReviewTable < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.references :user
      t.string :title
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
