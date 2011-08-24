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
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end

end
