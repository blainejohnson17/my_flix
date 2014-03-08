class RatingsController < ApplicationController
  before_filter :require_user

  def update_rating
    video = Video.find(params[:video_id])
    rating = video.ratings.where(user_id: current_user.id).first_or_initialize

    if params[:rating] == "0"
      rating.destroy
    else
      rating.value = params[:rating]
      rating.save
    end
    render nothing: true
  end
end