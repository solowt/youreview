class AddColToComments < ActiveRecord::Migration
  def change
    add_column :comments, :bookreview_id, :integer
  end
end
