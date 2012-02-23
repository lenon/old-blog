require "spec_helper"

describe "Blog" do
  let!(:first_post) do
    Post.create!({
      :title => "My Awesome Post",
      :content => "Foo Bar Baz"
    })
  end

  let!(:second_post) do
    Post.create!({
      :title => "My Awesome Post 2",
      :content => "Foo Bar Baz"
    })
  end

  describe "GET /" do
    it "should list all posts" do
      get "/"

      last_response.should be_ok
      last_response.body.should include first_post.title
      last_response.body.should include second_post.title
    end
  end

  describe "GET /post/:slug" do
    it "should show the post" do
      get "/post/#{first_post.slug}/"

      last_response.should be_ok
      last_response.body.should include first_post.title
      last_response.body.should_not include second_post.title
    end

    it "should return HTTP 404 when post is not found" do
      get "/post/post-que-no-ecziste/"

      last_response.status.should == 404
    end
  end
end
