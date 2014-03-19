class Admin::VideosController < AdminsController
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
    params.require(:video).permit(:title, :category_id, :description, :large_cover, :small_cover, :video_url)
  end
end