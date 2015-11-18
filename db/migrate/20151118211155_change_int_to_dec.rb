class ChangeIntToDec < ActiveRecord::Migration
  def change
    remove_column :movieworks, :vote_avg
    add_column :movieworks, :vote_ave, :float
  end
end
