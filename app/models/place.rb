class Place < ActiveRecord::Base

  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :name, presence: true

  has_many :reviews, dependent: :destroy
  has_many :users, through: :reviews
end
