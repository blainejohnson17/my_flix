require 'spec_helper'

describe Admin::VideosController do
  
  it_behaves_like 'require sign in' do
    let(:action) { get :new }
  end

  it "sets @video to a new video" do
    set_current_admin
    get :new
    expect(assigns(:video)).to be_new_record
    expect(assigns(:video)).to be_instance_of Video
  end

  it "redirects to home page for non admin users" do
    set_current_user
    get :new
    expect(response).to redirect_to home_path
  end
  it "sets error messege" do
    set_current_user
    get :new
    expect(flash[:error]).to be_present
  end
end