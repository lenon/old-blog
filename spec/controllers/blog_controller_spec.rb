require "spec_helper"

describe BlogController do
  def app; BlogController; end

  let!(:first_post)  { create :post }
  let!(:second_post) { create :post }
  let!(:unpublished) { create :post, :published => false }

  describe "GET /" do
    it "lists all published posts" do
      get "/"

      last_response.should be_ok
      last_response.body.should include first_post.title
      last_response.body.should include second_post.title
      last_response.body.should_not include unpublished.title
    end
  end

  describe "GET /post/:slug" do
    it "shows post content" do
      get "/post/#{first_post.slug}"

      last_response.should be_ok
      last_response.body.should include first_post.title
    end

    it "returns 404 when post is not found" do
      get "/post/post-que-no-ecziste"
      last_response.status.should == 404
    end
  end
end
