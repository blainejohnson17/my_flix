class ReviewsController < ApplicationController
  before_filter :require_user
  
  def create
    @video = Video.find(params[:video_id])
    @review = @video.reviews.first_or_initialize(user: current_user)
    @review.content = review_params[:content]

    if @review.save
      flash[:notice] = "Your review was created!"
      redirect_to @video
    else
      @reviews = @video.reviews.reload
      flash[:error] = "You need to add review text to create a review!"
      render 'videos/show'
    end
  end

  def update_rating
    video = Video.find(params[:video_id])
    review = video.reviews.first_or_initialize(user: current_user)
    review.rating = params[:rating]
    review.save(validate: false)
    render nothing: true
  end

  private

  def review_params
    params.require(:review).permit(:content, :rating)
  end
end