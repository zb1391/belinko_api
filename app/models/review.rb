class Review < ActiveRecord::Base

  validates :comment,  presence: true
  validates :user_id,  presence: true
  validates :place_id, presence: true

  belongs_to :user
  belongs_to :place
end
