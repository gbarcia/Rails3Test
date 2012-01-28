require 'spec_helper'

describe UsersController do
  render_views

  describe "GET show" do
    before(:each) do
      @user = Factory(:user)
    end

    it "deberia ser correcto" do
      get :show, :id => @user
      response.should be_success
    end

    it "debe encontrar el usuario correcto" do
      get :show, :id => @user
      assigns(:user).should == @user
    end

    it "debe tener una imagen de perfil" do
      get :show, :id => @user
      response.should have_selector("h1> img", :class => "gravatar")
    end
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end

    it "debe tener el titulo correcto" do
      get :new
      response.should_not have_selector("title", :content => "Sing up")
    end
  end

  describe "POST create" do
    describe "failure" do
      before(:each) do
        @attr = {:name => "", :email => "", :password => "", :password_confirmation => ""}
      end

      it "no deberia crear el usuario" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User,:count)
      end

      it "deberia tener el titulo correcto" do
        post :create, :user => @attr
        response.should_not have_selector("title", :content => "Sing up")
      end

      it "deberia hacer render de la new page" do
        post :create, :user => @attr
        response.should render_template('new')
      end
    end

    describe "success" do
      before(:each) do
        @attr = {:name => "New User", :email => "user@example.com",
                 :password => "foobar", :password_confirmation => "foobar"}
      end

      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User,:count).by(1)
      end

      it "should redirect to the user show page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end

      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /Welcome to the Sample App!/i
      end

      it "should sign the user in" do
        post :create, :user => @attr
        controller.should be_signed_in
      end
    end

    describe "Sign in/out" do

      describe "failure" do
        it "should not sign a user in" do
          visit signin_path
          fill_in :email, :whit => " "
          fill_in :password, :whit => " "
          click_button
          response.should have_selector("div.flash.error", :content => "Invalid")
        end
      end

      describe "success" do
        it "should singin/out user" do
          user = Factory(:user)
          visit signin_path
          fill_in :email, :whit => user.email
          fill_in :password, :whit => user.password
          click_button
          controller.should be_signed_in
          click_link "Sign out"
          controller.should_not be_signed_in
        end
      end

    end

  end
end
