class CreateMovieworks < ActiveRecord::Migration
  def change
    create_table :movieworks do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.string :overview
      t.string :release_date
      t.string :medium
      t.integer :unique_id
      t.string :original_title
      t.string :poster_path
      t.string :backdrop_path
      t.integer :vote_avg
    end
  end
end
