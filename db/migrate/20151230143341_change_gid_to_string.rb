class ChangeGidToString < ActiveRecord::Migration
  def up
    change_column :places, :gid, :string
  end
  
  def down
    change_column :places, gid: :integer
  end
end
