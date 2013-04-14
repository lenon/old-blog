require "spec_helper"

describe Helpers do
  subject do
    klass = Class.new { include Helpers }
    klass.new
  end

  describe "#blog_settings" do
    before do
      subject.stub_chain(:request, :env).and_return({"HTTP_HOST" => http_host})
    end

    context "HTTP_HOST is empty" do
      let(:http_host) { nil }

      it "returns default blog settings" do
        subject.blog_settings.should be_kind_of BlogSettings
        subject.blog_settings.domain.should be_nil
      end
    end

    context "HTTP_HOST is not empty" do
      let(:http_host) { "other.example.com" }

      it "returns blog settings for given HTTP_HOST" do
        subject.blog_settings.should be_kind_of BlogSettings
        subject.blog_settings.domain.should be == "other.example.com"
      end
    end
  end

  describe "#blog_title" do
    it "returns blog title" do
      subject.stub_chain(:blog_settings, :title).and_return("blog title")
      subject.blog_title.should be == "blog title"
    end
  end

  describe "#blog_description" do
    it "returns blog description" do
      subject.stub_chain(:blog_settings, :description).and_return("blog description")
      subject.blog_description.should be == "blog description"
    end
  end

  describe "#blog_domain" do
    it "returns blog domain" do
      subject.stub_chain(:blog_settings, :domain).and_return("example.com")
      subject.blog_domain.should be == "example.com"
    end
  end

  describe "#asset_url" do
    context "RACK_ENV is production" do
      let(:release_file) { File.expand_path("RELEASE_NAME") }

      it "returns Setting.assets_domain + RELEASE_NAME + source path" do
        File.should_receive(:exists?).with(release_file).and_return(true)
        File.should_receive(:read).with(release_file).and_return("RELEASE-TIMESTAMP\n")
        ENV.stub(:[] => "production")

        subject.asset_url("/foo/bar.css").should be == "http://assets.example.com/RELEASE-TIMESTAMP/foo/bar.css"
      end
    end

    context "RACK_ENV is not production" do
      it "returns source path" do
        ENV.stub(:[] => "test")
        subject.asset_url("/foo/bar.css").should be == "/foo/bar.css"
      end
    end
  end
end
