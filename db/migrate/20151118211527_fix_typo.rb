class FixTypo < ActiveRecord::Migration
  def change
    remove_column :movieworks, :vote_ave
    add_column :movieworks, :vote_avg, :float
  end
end
