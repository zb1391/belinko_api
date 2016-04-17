class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships, force: true do |t|
      t.integer "user_id", null: false
      t.integer "friend_id", null: false
    end
  end
end
