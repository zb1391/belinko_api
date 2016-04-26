class AddWouldRecommendToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :would_recommend, :boolean
  end
end
