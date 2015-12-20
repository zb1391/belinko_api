class CreatePlaces < ActiveRecord::Migration
  def up
    create_table :places, id: false do |t|
      t.string :name
      t.string :latitude
      t.string :longitude
      t.string :lat_long

      t.timestamps null: false
    end

    # make lat_long our primary key
    execute "ALTER TABLE places ADD PRIMARY KEY (lat_long);"
  end

  def down
    drop_table :places
  end
end
