class EditStuff < ActiveRecord::Migration
  def change
    remove_column :bookreviews, :work_id
    add_reference :bookreviews, :bookwork, index: true
  end
end
