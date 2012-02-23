require "spec_helper"

describe "Admin" do
  let(:admin) do
    Admin.create!({
      :login => "admin",
      :password => "123456"
    })
  end

  let(:blog_post) do
    Post.create!({
      :title => "My Post",
      :content => "My post content"
    })
  end

  describe "GET /login" do
    it "should show the login form" do
      get "/login"

      last_response.should be_ok
      last_response.body.should include "Username"
      last_response.body.should include "Password"
    end
  end

  describe "POST /login" do
    it "should authenticate user when username and password are valid" do
      Admin.should_receive(:authenticate).with("admin", "123456").and_return(admin)

      post "/login", :login => "admin", :password => "123456"

      last_response.status.should == 302
      last_response.location.should =~ /\/admin$/
    end

    it "should not authenticate user when username and password are not valid" do
      Admin.should_receive(:authenticate).with("admin", "123456").and_return(false)

      post "/login", :login => "admin", :password => "123456"

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

  describe "GET /admin" do
    it_should_behave_like "an area that requires authentication", "/admin"

    it "should show the dashboard" do
      get "/admin", {}, session

      last_response.should be_ok
      last_response.body.should include "Dashboard"
    end
  end

  describe "GET /admin/new-post" do
    it_should_behave_like "an area that requires authentication", "/admin/new-post"

    it "should show the new post form" do
      get "/admin/new-post", {}, session

      last_response.should be_ok
      last_response.body.should include "New post"
    end
  end

  describe "POST /admin/new-post" do
    it_should_behave_like "an area that requires authentication", "/admin/new-post", :post

    let(:params) do
      {
        "title" => "New blog post title",
        "content" => "Blog post content"
      }
    end

    it "should not create a new post when data is not valid" do
      blog_post.should_receive(:save)
               .and_return(false)

      Post.should_receive(:new).with(params)
          .and_return(blog_post)

      post "/admin/new-post", { :post => params }, session

      last_response.should_not be_redirect
      last_response.body.should include "your post cannot be created"
    end

    it "should create a new post and redirect to this post when data is valid" do
      blog_post.should_receive(:save)
               .and_return(true)

      Post.should_receive(:new).with(params)
          .and_return(blog_post)

      post "/admin/new-post", { :post => params }, session

      last_response.should be_redirect
      last_response.location.should =~ /\/post\/#{Regexp.escape blog_post.slug}\//
    end
  end

  describe "GET /admin/edit-post/:id" do
    it_should_behave_like "an area that requires authentication", "/admin/edit-post/11111"

    it "should show the a form to edit the post" do
      get "/admin/edit-post/#{blog_post.id}", {}, session

      last_response.should be_ok
      last_response.body.should include "Edit post"
    end
  end

  describe "PUT /admin/edit-post/:id" do
    it_should_behave_like "an area that requires authentication", "/admin/edit-post/11111", :put

    let(:params) do
      {
        "title" => "New title",
        "content" => "Post content"
      }
    end

    it "should not update the post when data is not valid" do
      blog_post.should_receive(:update_attributes).with(params)
               .and_return(false)

      Post.should_receive(:find).with(blog_post.id.to_s)
          .and_return(blog_post)

      put "/admin/edit-post/#{blog_post.id}", { :post => params }, session

      last_response.should_not be_redirect
      last_response.body.should include "your post cannot be updated"
    end

    it "should update the post when data is valid" do
      blog_post.should_receive(:update_attributes).with(params)
               .and_return(true)

      Post.should_receive(:find).with(blog_post.id.to_s)
          .and_return(blog_post)

      put "/admin/edit-post/#{blog_post.id}", { :post => params }, session

      last_response.should be_redirect
      last_response.location.should =~ /\/post\/#{Regexp.escape blog_post.slug}\//
    end
  end

  describe "GET /admin/delete-post/:id" do
    it_should_behave_like "an area that requires authentication", "/admin/delete-post/11111"

    it "should show a confirmation message" do
      Post.should_receive(:find).with(blog_post.id.to_s).and_return(blog_post)

      get "/admin/delete-post/#{blog_post.id}", {}, session

      last_response.should be_ok
      last_response.body.should include "Do you really want to delete"
      last_response.body.should include blog_post.title
      last_response.body.should include "Yes, I want to delete this post"
      last_response.body.should include "No, get me out of here!"
    end
  end

  describe "DELETE /admin/delete-post/:id" do
    it_should_behave_like "an area that requires authentication", "/admin/delete-post/11111", :delete

    it "should destroy the post" do
      delete "/admin/delete-post/#{blog_post.id}", {}, session

      last_response.should be_redirect
      last_response.location.should =~ /\/admin$/

      Post.find(blog_post.id.to_s).should be_nil
    end
  end

  describe "POST /admin/markdown-preview" do
    it_should_behave_like "an area that requires authentication", "/admin/markdown-preview", :post

    it "should render the html version of a markdown content" do
      mdown = <<-EOMD
# TITLE
content
      EOMD

      post "/admin/markdown-preview", { :text => mdown }, session

      last_response.should be_ok
      last_response.body.should include "<h1>TITLE</h1>"
      last_response.body.should include "<p>content</p>"
    end
  end

  def session
    { "rack.session" => { :admin_id => admin.id } }
  end
end
