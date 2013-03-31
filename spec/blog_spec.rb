require "spec_helper"

describe "BlogApp" do
  def app; BlogApp; end

  let!(:first_post) { create :post }
  let!(:second_post) { create :post }
  let!(:third_post) { create :post, :domain => "foobar.com" }

  describe "GET /" do
    specify "default domain will be used to filter posts" do
      get "/"

      last_response.should be_ok
      last_response.body.should include first_post.title
      last_response.body.should include second_post.title
      last_response.body.should_not include third_post.title
    end

    specify "given domain will be used to filter posts" do
      get "/", {}, "HTTP_HOST" => "foobar.com"

      last_response.should be_ok
      last_response.body.should_not include first_post.title
      last_response.body.should_not include second_post.title
      last_response.body.should include third_post.title
    end
  end

  describe "GET /post/:slug" do
    it "should show the post" do
      get "/post/#{first_post.slug}"

      last_response.should be_ok
      last_response.body.should include first_post.title
      last_response.body.should_not include second_post.title
    end

    it "should return HTTP 404 when post is not found" do
      get "/post/post-que-no-ecziste"

      last_response.status.should == 404
    end

    specify "domain will be used to filter a post" do
      get "/post/#{first_post.slug}", {}, "HTTP_HOST" => "foobar.com"

      last_response.status.should == 404
    end
  end
end
