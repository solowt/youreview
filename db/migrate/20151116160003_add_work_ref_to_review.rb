class AddWorkRefToReview < ActiveRecord::Migration
  def change
    add_reference :reviews, :work, index: true
  end
end
