class Api::V1::ReviewsController < ApplicationController
  before_action :authenticate_with_token!, only: [:create]

  def create
    place = Place.find_or_initialize_by(review_params[:place])
    review = place.reviews.build(review_params.except(:place))
    review.user_id = current_user.id

    if place.save
      opts = { user: { only: [:name, :id, :thumbnail] } }
      render json: review, include: opts, status: 201
    else
      render json: { errors: place.errors }, status: 422
    end
  end

  private
  def review_params
    params.require(:review).permit(:comment, :user_id, :place_id,
      :place => [:name, :latitude, :longitude, :gid, :would_recommend])
  end
end
