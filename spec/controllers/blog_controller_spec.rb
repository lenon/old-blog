require "spec_helper"

describe BlogController do
  def app; BlogController; end

  let!(:first_post) { create :post }
  let!(:second_post) { create :post }
  let!(:third_post) { create :post, :domain => "other.example.com" }

  describe "GET /" do
    context "HTTP_HOST is empty" do
      it "list all posts using the default domain as filter" do
        get "/"

        last_response.should be_ok
        last_response.body.should include first_post.title
        last_response.body.should include second_post.title
        last_response.body.should_not include third_post.title
      end
    end

    context "HTTP_POST is set" do
      it "list all posts using HTTP_HOST as domain filter" do
        get "/", {}, "HTTP_HOST" => "other.example.com"

        last_response.should be_ok
        last_response.body.should_not include first_post.title
        last_response.body.should_not include second_post.title
        last_response.body.should include third_post.title
      end
    end
  end

  describe "GET /post/:slug" do
    context "HTTP_HOST is empty" do
      it "show a post associated with default domain" do
        get "/post/#{first_post.slug}"

        last_response.should be_ok
        last_response.body.should include first_post.title
        last_response.body.should_not include second_post.title
      end

      it "returns 404 for a post associated with another domain" do
        get "/post/#{first_post.slug}", {}, "HTTP_HOST" => "other.example.com"
        last_response.status.should be 404
      end
    end

    context "HTTP_HOST is set" do
      it "show a post associated with HTTP_HOST" do
        get "/post/#{third_post.slug}", {}, "HTTP_HOST" => "other.example.com"

        last_response.should be_ok
        last_response.body.should include third_post.title
      end
    end

    it "returns 404 when post is not found" do
      get "/post/post-que-no-ecziste"
      last_response.status.should == 404
    end
  end
end
