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
      resonse.should have_selector("title", :content => "Sing up")
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
        response.should have_selector("title", :content => "Sing up")
      end

      it "deberia hacer render de la new page" do
        post :create, :user => @attr
        resonse.should render_template('new')
      end

    end
  end

end
