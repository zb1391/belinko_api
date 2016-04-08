class AddLikesToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :likes, :integer
    add_column :places, :dislikes, :integer
  end
end
