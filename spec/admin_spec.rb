require "spec_helper"

describe "Admin" do
  before do
    Admin.delete_all
    @admin = Admin.create!({
      :login => "admin",
      :password => "123456"
    })

    Post.delete_all
    @post = Post.create!({
      :title => "My Post",
      :content => "My post content"
    })
  end

  describe "when a request hits the /login path" do
    it "should show the login form" do
      get "/login"

      last_response.should be_ok
      last_response.body.should include "Username"
      last_response.body.should include "Password"
    end
  end

  describe "when a post request hits the /login path" do
    it "should authenticate user when username and password are valid" do
      post "/login", :login => "admin", :password => "123456"

      last_response.status.should == 302
      last_response.location.should =~ /\/admin$/
    end

    it "should not authenticate user when username and password are not valid" do
      post "/login", :login => "admin", :password => "1234567"

      last_response.status.should == 200
      last_response.should_not be_redirect
      last_response.body.should include "Username"
      last_response.body.should include "Password"
    end
  end

  shared_examples_for "an area that requires authentication" do |path, http_verb = :get|
    it "should redirect to login when admin is not logged in" do
      send(http_verb, path)

      last_response.status.should == 302
      last_response.location.should =~ /\/login$/
    end
  end

  describe "when a request hits the /admin path" do
    it_should_behave_like "an area that requires authentication", "/admin"

    it "should show the dashboard" do
      get "/admin", {}, "rack.session" => { :admin_id => @admin.id }

      last_response.should be_ok
    end
  end

  describe "when a request hits the /admin/new-post path" do
    it_should_behave_like "an area that requires authentication", "/admin/new-post"

    it "should show the new post form" do
      get "/admin/new-post", {}, "rack.session" => { :admin_id => @admin.id }

      last_response.should be_ok
      last_response.body.should include "New post"
    end
  end

  describe "when a post request hits the /admin/new-post path" do
    it_should_behave_like "an area that requires authentication", "/admin/new-post", :post

    it "should not create a new post when data is not valid" do
      post "/admin/new-post", {}, "rack.session" => { :admin_id => @admin.id }

      last_response.should_not be_redirect
      last_response.body.should include "your post cannot be created"
    end

    it "should create a new post and redirect to this post when data is valid" do
      params = { :title => "My new post", :content => "Content of my new post" }

      post "/admin/new-post", { :post => params }, "rack.session" => { :admin_id => @admin.id }

      last_response.should be_redirect
      last_response.location.should =~ /\/post\/#{Regexp.escape Post.last.slug}\//
    end
  end

  describe "when a request hits the /admin/edit-post/ path" do
    it_should_behave_like "an area that requires authentication", "/admin/edit-post/11111"

    it "should show the a form to edit the post" do
      get "/admin/edit-post/#{@post.id}", {}, "rack.session" => { :admin_id => @admin.id }

      last_response.should be_ok
      last_response.body.should include "Edit post"
    end
  end

  describe "when a put request hits the /admin/edit-post/ path" do
    pending
  end

  describe "when a request hits the /admin/delete-post/ path" do
    pending
  end

  describe "when a delete request hits the /admin/delete-post/ path" do
    pending
  end

  describe "when a post request hits the /admin/markdown-preview/ path" do
    pending
  end
end
