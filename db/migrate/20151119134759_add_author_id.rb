class AddAuthorId < ActiveRecord::Migration
  def change
    add_column :bookworks, :author_id, :integer
  end
end
