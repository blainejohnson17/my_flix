class QueueItemsController < ApplicationController
  before_filter :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])
    queue_item = QueueItem.create(video: video, user: current_user, position: new_queue_item_position )
    redirect_to my_queue_path
  end

  def destroy
    queue_item = QueueItem.find(params[:id])
    if current_user.queue_items.include?(queue_item)
      queue_item.destroy
      current_user.normalize_queue_items_positions
    end
    redirect_to my_queue_path
  end

  def update_queue
    @queue_items_sorted = params[:queue_items].sort_by { |qi| qi['position'] }
    if !queue_item_data_valid? || !queue_item_data_complete?
      redirect_to my_queue_path
      return
    end
    @queue_items_sorted.each_with_index do |queue_item_data, index|
      queue_item = QueueItem.find(queue_item_data[:id])
      queue_item.update_attributes(position: index + 1)
    end
    redirect_to my_queue_path
  end

  def drag_sort
    params[:queue_item].each_with_index do |id, index|
      QueueItem.update_all({position: index+1}, {id: id})
    end
    render nothing: true
  end

  private

  def queue_item_data_valid?
    @queue_items_sorted.each do |queue_item_data|
      return false if QueueItem.find(queue_item_data[:id]).user != current_user
    end
  end

  def queue_item_data_complete?
    @queue_items_sorted.count == current_user.queue_items.count
  end

  def new_queue_item_position
    current_user.queue_items.count + 1
  end
end