class Admin::VideosController < ApplicationController
  before_filter :require_user, :require_admin

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    if @video.save
      flash[:success] = "#{@video.title} has been created!"
      redirect_to new_admin_video_path
    else
      flash[:error] = "Your video was not added, please check your input"
      render :new
    end
  end

  private

  def video_params
    params.require(:video).permit(:title, :category_id, :description)
  end

  def require_admin
    if !current_user.admin
      flash[:error] = "You are not authorized to do that!"
      redirect_to home_path unless current_user.admin?
    end
  end
end