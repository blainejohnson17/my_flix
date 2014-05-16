class CategoriesController < ApplicationController
  before_filter :require_user

  def show
    @category = Category.find(params[:id])
    @videos = Video.where(category_id: @category.id).paginate(:page => params[:page])
    respond_to do |format|
      format.html
      format.js
    end
  end
end