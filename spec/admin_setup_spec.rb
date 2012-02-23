require "spec_helper"

describe "Admin setup" do
  before do
    Admin.delete_all
  end

  describe "when a request hits the /setup path" do
    it "should show a form to fill the admin information" do
      get "/setup"

      last_response.should be_ok
      last_response.body.should include "Welcome to the admin setup"
    end

    it "should return HTTP 404 when an admin already exists" do
      Admin.create!({
        :login => "admin",
        :password => "123456"
      })

      get "/setup"

      last_response.status.should == 404
    end
  end

  describe "when a post request hits the /setup path" do
    it "should redirect to /login when params are valid" do
      post "/setup", { :login => "12456", :password => "123456", :password_confirmation => 123456 }

      last_response.status.should == 302
      last_response.location.should =~ /\/login$/
    end

    it "should return HTTP 404 when an admin already exists" do
      Admin.create!({
        :login => "admin",
        :password => "123456"
      })

      post "/setup"

      last_response.status.should == 404
    end
  end
end
