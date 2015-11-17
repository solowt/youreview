class AddIdCol < ActiveRecord::Migration
  def change
    add_column :works, :unique_id, :string
  end
end
