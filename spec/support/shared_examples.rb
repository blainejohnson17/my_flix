shared_examples "requires sign in" do
  it "redirects to sign in page" do
    clear_current_user
    action
    expect(response).to redirect_to sign_in_path
  end
end

shared_examples "requires sign out" do
  it "redirects to home page" do
    set_current_user
    action
    expect(response).to redirect_to home_path
  end
end

shared_examples "requires admin" do
  it "redirects to home page for non admin users" do
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

shared_examples "sets user" do
  it "assigns the requested user to @user" do
    action
    expect(assigns(:user)).to eq(user)
  end
end

shared_examples "requires owner" do
  it "redirects to home_path if current user is not the owner" do
    action
    expect(response).to redirect_to home_path
  end

  it "sets error message" do
    action
    expect(flash[:error]).to be_present
  end
end
