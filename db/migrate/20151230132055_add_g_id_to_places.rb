class AddGIdToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :gid, :integer
  end
end
