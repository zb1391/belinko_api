class AddIndexToGId < ActiveRecord::Migration
  def change
    add_index :places, :gid
  end
end
