class Place < ActiveRecord::Base
  attr_accessor :would_recommend
  acts_as_mappable default_units: :kms,
                   lat_column_name: :latitude, 
                   lng_column_name: :longitude

  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :name, presence: true
  validates :gid, presence: true

  has_many :reviews, dependent: :destroy
  has_many :users, through: :reviews

  accepts_nested_attributes_for :reviews
  before_save :update_recommendations


  # for now just return latitude/longitude/gid/name
  # maybe if we keep track of more data eventually do different things
  # based on he type of search (nearby,radar,text)
  def as_google_json
    {
      "place_id" => gid,
      "name" => name,
      "geometry" => {
        "lat" => latitude,
        "lng" => longitude,
      }
    }
  end

  # update the places like/dislike count
  def update_recommendations
    if self.would_recommend
      self.likes = (self.likes || 0) + 1
    else
      self.dislikes = (self.dislikes || 0) + 1
    end
  end

  # returns places where the author is in the array of ids
  def self.reviewed_by(ids)
    Place.joins(:reviews).where(reviews: { user_id: ids })
  end
end
