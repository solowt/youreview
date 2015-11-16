class AddColsToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :category, :string
    add_column :reviews, :name, :string
    add_column :reviews, :score, :integer    
  end
end
