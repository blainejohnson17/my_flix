require 'spec_helper'

describe QueueItemsController do

  before { set_current_user }

  describe "GET #index" do

    let!(:queue_item1) { Fabricate(:queue_item, position: 1, user: current_user) }
    let!(:queue_item2) { Fabricate(:queue_item, position: 2, user: current_user) }

    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end

    it "assigns all queue_items to @queue_items for authenticated user" do
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end

    it "orders queue_items with position" do
      get :index
      expect(assigns(:queue_items)).to eq([queue_item1, queue_item2])
    end
  end

  describe "POST #create" do

    let(:gooneys) { video = Fabricate(:video) }

    it_behaves_like "requires sign in" do
      let(:action) { post :create }
    end

    it "redirects to the my queue page" do
      post :create, video_id: gooneys.id
      expect(response).to redirect_to my_queue_path
    end

    it "saves new queue item to the database" do
      post :create, video_id: gooneys.id
      expect(QueueItem.count).to eq(1)
    end

    it "creates new queue item associated to the video with id in params" do
      post :create, video_id: gooneys.id
      expect(QueueItem.first.video).to eq(gooneys)
    end

    it "creates new queue item associated with the signed in user" do
      post :create, video_id: gooneys.id
      expect(QueueItem.first.user).to eq(current_user)
    end

    it "creates new queue item as in last position" do
      Fabricate(:queue_item, user: current_user, video: gooneys)
      ghost_busters = Fabricate(:video)
      post :create, video_id: ghost_busters.id
      ghost_busters_queue_item = QueueItem.where(video_id: ghost_busters.id, user_id: current_user.id).first
      expect(ghost_busters_queue_item.position).to eq(2)
    end

    it "does not create new queue item if queue item already exists for that video and user" do
      Fabricate(:queue_item, user: current_user, video: gooneys)
      post :create, video_id: gooneys.id
      expect(current_user.queue_items.count).to eq(1)
    end
  end

  describe "DELETE #destroy" do

    it_behaves_like "requires sign in" do
      let(:action) { delete :destroy, id: 1 }
    end

    it "redirects to my_queue page" do
      queue_item = Fabricate(:queue_item, user: current_user)
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to my_queue_path
    end

    it "deletes queue item" do
      queue_item = Fabricate(:queue_item, user: current_user)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(0)
    end

    it "doesn't delete queue item if queue item is not in the current users queue" do        
      other_user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: other_user)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(1)
    end

    it "normalizes the remaining queue_items" do
      queue_item1 = Fabricate(:queue_item, position: 1, user: current_user)
      queue_item2 = Fabricate(:queue_item, position: 2, user: current_user)
      delete :destroy, id: queue_item1.id
      expect(QueueItem.first.position).to eq(1)
    end
  end

  describe "POST #update_queue" do
    
    let!(:queue_item1) { Fabricate(:queue_item, position: 1, user: current_user) }
    let!(:queue_item2) { Fabricate(:queue_item, position: 2, user: current_user) }

    it_behaves_like "requires sign in" do
      let(:action) { post :update_queue }
    end

    context "with complete input" do
      
      it "redirects to my queue page" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end

      it "updates position of all queue items in users queue" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(queue_item1.reload.position).to eq(2)
        expect(queue_item2.reload.position).to eq(1)
      end

      it "normalizes all queue_item positions in users queue" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 1}]
        expect(queue_item1.reload.position).to eq(2)
        expect(queue_item2.reload.position).to eq(1)
      end
    end

    context "with incomplete input" do

      it "redirects to my queue page" do
        post :update_queue, queue_items: [{id: queue_item2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end

      it "doesn't update any queue_items" do
        post :update_queue, queue_items: [{id: queue_item2.id, position: 1}]
        expect(queue_item1.reload.position).to eq(1)
        expect(queue_item2.reload.position).to eq(2)
      end
    end

    context "with queue_items from another users queue" do

      let!(:queue_item3) { Fabricate(:queue_item, position: 3, user: Fabricate(:user)) }
      
      it "redirects to my queue page" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item3.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end

      it "doesn't change any of the queue_items" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item3.id, position: 1}]
        expect(queue_item1.reload.position).to eq(1)
        expect(queue_item2.reload.position).to eq(2)
      end
    end
  end

  describe "#drag_sort" do

    let!(:queue_item1) { Fabricate(:queue_item, position: 1, user: current_user) }
    let!(:queue_item2) { Fabricate(:queue_item, position: 2, user: current_user) }

    it_behaves_like "requires sign in" do
      let(:action) { post :drag_sort }
    end

    it "renders nothing" do
      post :drag_sort, queue_item: [queue_item2.id, queue_item1.id]
      expect(response).to have_text(" ")
    end

    it "updates position of all queue items" do
      post :drag_sort, queue_item: [queue_item2.id, queue_item1.id]
      expect(queue_item1.reload.position).to eq(2)
      expect(queue_item2.reload.position).to eq(1)
    end
  end

  describe "#update_rating" do

    let!(:queue_item1) { Fabricate(:queue_item, position: 1, user: current_user) }
    let!(:review) { Fabricate(:review, video: queue_item1.video, rating: 1, user: current_user) }

    it_behaves_like "requires sign in" do
      let(:action) { post :update_rating }
    end

    it "renders nothing" do
      post :update_rating, queue_item_id: queue_item1.video.id, rating: 3
      expect(response).to have_text(" ")
    end

    it "updates rating of given video on users review" do
      post :update_rating, queue_item_id: queue_item1.video.id, rating: 3
      expect(review.reload.rating).to eq(3)
    end
  end
end