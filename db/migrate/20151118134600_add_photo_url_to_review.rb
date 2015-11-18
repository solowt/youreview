class AddPhotoUrlToReview < ActiveRecord::Migration
  def change
    add_column :reviews, :photo_url, :string
  end
end
