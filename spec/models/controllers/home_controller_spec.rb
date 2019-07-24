require 'rails_helper'

RSpec.describe HomeController, type: :controller do

  before(:all) do
  end

  describe "GET index page" do
    context 'not logged in' do
      it "redirect to login page" do
        get :index
      end
    end

    context "logged in" do
      it "redirects to home page" do
        get :index
      end
    end
  end

end
