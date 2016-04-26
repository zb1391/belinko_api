class Review < ActiveRecord::Base
  validates :comment,  presence: true
  validates_presence_of :user
#  validates_presence_of :place

  belongs_to :user
  belongs_to :place

  scope :reviewed_by, -> (ids) { where( user_id: ids) }
end
