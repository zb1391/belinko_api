class Place < ActiveRecord::Base

  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :name, presence: true

end
