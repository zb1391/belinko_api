class CreatePlaces < ActiveRecord::Migration
  def up
    create_table :places do |t|
      t.string :name
      t.float :latitude
      t.float :longitude

      t.timestamps null: false
    end

    add_index :places, :latitude
    add_index :places, :longitude
  end

  def down
    drop_table :places
  end
end
