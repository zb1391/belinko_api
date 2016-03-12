class Place < ActiveRecord::Base
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
end
