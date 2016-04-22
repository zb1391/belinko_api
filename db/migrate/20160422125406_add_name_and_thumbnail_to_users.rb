class AddNameAndThumbnailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :thumbnail, :string
  end
end
