class EditStuffAgain < ActiveRecord::Migration
  def change
    remove_column :bookreviews, :phto_url
    add_column :bookreviews, :photo_url, :string
  end
end
