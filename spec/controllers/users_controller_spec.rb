require 'rails_helper'
include SessionsHelper

RSpec.describe UsersController, type: :controller do
  let(:new_user_attributes) do
    {
      name: "Blochead",
      email: "blochead@bloc.io",
      password: "blochead",
      password_confirmation: "blochead"
    }
  end

  let(:my_user) {create(:user)}
  let(:my_topic) {create(:topic)}
  let(:my_post) {create(:post)}
  let(:other_post) {create(:post)}

  describe "GET show" do
    before do
      create_session(my_user)
    end

    it "renders the show view" do
      get :show, params: {id: my_user.id}
      expect(response).to have_http_status(:success)
    end

    it "displays favorited posts" do
      my_favorite = Favorite.create(user: my_user, post: other_post)
      expect(my_user.favorites.count).to eq(1)
    end

    it "displays the number of comments for the favorited post" do
      expect(other_post.comments.count).to eq(0)
    end

    it "displays the number of votes for the favorited post" do
      expect(other_post.votes.count). to eq(0)
    end
  end

  describe "GET new" do
    it "returns https success" do
      get :new
      expect(response).to have_http_status(:success)
    end

    it "instantiates a new user" do
      get :new
      expect(assigns(:user)).to_not be_nil
    end
  end

  describe "POST create" do
    it "returns an http redirect" do
      post :create, params: {user: new_user_attributes}
      expect(response).to have_http_status(:redirect)
    end

    it "creates a new user" do
      expect{
        post :create, params: {user: new_user_attributes}
      }.to change(User, :count).by(1)
    end

    it "sets user name properly" do
      post :create, params: {user: new_user_attributes}
      expect(assigns(:user).name).to eq new_user_attributes[:name]
    end

    it "sets user email properly" do
      post :create, params: {user: new_user_attributes}
      expect(assigns(:user).email).to eq new_user_attributes[:email]
    end

    it "sets user password properly" do
      post :create, params: { user: new_user_attributes }
      expect(assigns(:user).password).to eq new_user_attributes[:password]
    end

    it "sets user password_confirmation properly" do
      post :create, params: { user: new_user_attributes }
      expect(assigns(:user).password_confirmation).to eq new_user_attributes[:password_confirmation]
     end

     it "logs the user in after sign up" do
       post :create, params: { user: new_user_attributes }
       expect(session[:user_id]).to eq assigns(:user).id
     end
  end

  describe "not signed in" do
    let(:factory_user) { create(:user) }

    before do
      post :create, params: {user: new_user_attributes}
    end

    it "returns http success" do
      get :show, params: {id: factory_user.id}
      expect(response).to have_http_status(:success)
    end

    it "renders the #show view" do
      get :show, params: {id: factory_user.id}
      expect(response).to render_template :show
    end

    it "assigns factory_user to @user" do
      get :show, params: {id: factory_user.id}
      expect(assigns(:user)).to eq(factory_user)
    end
  end
end
