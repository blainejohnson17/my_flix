class Admin::VideosController < ApplicationController
  before_filter :require_user, :require_admin

  def new
    @video = Video.new
  end

  private

  def require_admin
    if !current_user.admin
      flash[:error] = "You do not have access to that area!"
      redirect_to home_path unless current_user.admin?
    end
  end
end