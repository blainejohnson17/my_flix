class VideosController < ApplicationController
  before_filter :require_user

  def index
    @categories = Category.all
  end

  def show
    @video = Video.find(params[:id])
    @reviews = @video.reviews.where('content IS NOT NULL')
    @review = @video.reviews.where(user_id: current_user.id).first_or_initialize
  end

  def search
    @videos = Video.search_by_title(params[:term]).paginate(:page => params[:page])
    respond_to do |format|
      format.html
      format.js
    end
  end
end