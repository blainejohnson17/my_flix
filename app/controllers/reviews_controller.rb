class ReviewsController < ApplicationController
  before_filter :require_user
  
  def create
    @video = Video.find(params[:video_id])
    @review = @video.reviews.new(review_params.merge(user: current_user))

    if @review.save
      flash[:notice] = "Your review was created!"
      redirect_to @video
    else
      @reviews = @video.reviews.reload
      flash[:error] = "You need to add review text to create a review!"
      render 'videos/show'
    end
  end

  private

  def review_params
    params.require(:review).permit(:content)
  end
end