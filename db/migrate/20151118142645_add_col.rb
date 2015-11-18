class AddCol < ActiveRecord::Migration
  def change
    add_column :movieworks, :title, :string
  end
end
