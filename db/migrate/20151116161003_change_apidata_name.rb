class ChangeApidataName < ActiveRecord::Migration
  def change
    remove_column :works, 'api-data'
    add_column :works, :apidata, :json
  end
end
