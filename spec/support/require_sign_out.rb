shared_examples "require sign out" do
  it "redirects to home page" do
    set_current_user
    action
    expect(response).to redirect_to home_path
  end
end