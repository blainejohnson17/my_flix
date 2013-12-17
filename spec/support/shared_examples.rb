shared_examples "require sign in" do
  it "redirects to sign in page" do
    clear_current_user
    action
    expect(response).to redirect_to sign_in_path
  end
end

shared_examples "require sign out" do
  it "redirects to home page" do
    set_current_user
    action
    expect(response).to redirect_to home_path
  end
end

shared_examples "tokenable" do
    it "generates a random token attribute on create" do
    expect(object.token).to be_present
  end
end