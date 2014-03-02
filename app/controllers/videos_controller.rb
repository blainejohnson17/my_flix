class VideosController < ApplicationController
  before_filter :require_user
  def index
    @categories = Category.all
  end

  def show
    @video = Video.find(params[:id])
    @reviews = @video.reviews.where('content IS NOT NULL')
    @review = @video.reviews.first_or_initialize(user: current_user)
  end

  def search
    @videos = Video.search_by_title(params[:term])
  end
end