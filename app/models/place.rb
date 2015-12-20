class Place < ActiveRecord::Base
  validates :latitude, presence: true, uniqueness: true
  validates :longitude, presence: true, uniqueness: true
  validates :name, presence: true

end
