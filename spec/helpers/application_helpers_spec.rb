require "spec_helper"

describe ApplicationHelpers do
  subject do
    Class.new { include ApplicationHelpers }.new
  end

  describe "#blog_settings" do
    let(:settings) { subject.blog_settings }

    context "request's HTTP_HOST is empty" do
      before { stub_http_host("") }

      it "returns default blog settings" do
        expect(settings).to be_kind_of BlogSettings
        expect(settings.domain).to be_nil
      end
    end

    context "request's HTTP_HOST isn't described on settings.yml" do
      before { stub_http_host("missing.example.com") }

      it "returns default blog settings" do
        expect(settings).to be_kind_of BlogSettings
        expect(settings.domain).to be_nil
      end
    end

    context "request's HTTP_HOST is described on settings.yml" do
      before { stub_http_host("other.example.com") }

      it "returns settings for the given host" do
        expect(settings).to be_kind_of BlogSettings
        expect(settings.domain).to be == "other.example.com"
      end
    end
  end

  describe "#blog_title" do
    before { stub_blog_setting(:title, "blog title") }

    it "returns blog's title" do
      expect(subject.blog_title).to be == "blog title"
    end
  end

  describe "#blog_description" do
    before { stub_blog_setting(:description, "blog description") }

    it "returns blog's description" do
      expect(subject.blog_description).to be == "blog description"
    end
  end

  describe "#blog_domain" do
    before { stub_blog_setting(:domain, "example.com") }

    it "returns blog's domain" do
      expect(subject.blog_domain).to be == "example.com"
    end
  end

  describe "#asset_url" do
    let(:asset_url) { subject.asset_url("/foo/bar.css") }

    context "RACK_ENV is production" do
      before do
        stub_release_file("RELEASE-TIMESTAMP")
        stub_env("production")
      end

      it "returns Setting.assets_domain + RELEASE NAME + given path" do
        expect(asset_url).to be == "http://assets.example.com/RELEASE-TIMESTAMP/foo/bar.css"
      end
    end

    context "RACK_ENV is production and Settings.assets_domain is empty" do
      before do
        Settings.stub(:assets_domain => nil)
        stub_env("production")
      end

      it "returns given path" do
        expect(asset_url).to be == "/foo/bar.css"
      end
    end

    context "RACK_ENV isn't production" do
      before { stub_env("development") }

      it "returns given path" do
        expect(asset_url).to be == "/foo/bar.css"
      end
    end
  end

  describe "#page_title" do
    let(:page_title) { subject.page_title }

    context "instance variable @title isn't set" do
      before { stub_blog_setting(:home_title, "home page title") }

      it "returns blog's default page title" do
        expect(page_title).to be == "home page title"
      end
    end

    context "instance variable @title is set" do
      before { stub_blog_setting(:post_title, "blog post %s title") }

      it "returns blog's post title" do
        subject.instance_variable_set(:@title, "foo bar baz")
        expect(page_title).to be == "blog post foo bar baz title"
      end
    end
  end

  def stub_http_host(host)
    subject.stub_chain(:request, :env).and_return({
      "HTTP_HOST" => host
    })
  end

  def stub_blog_setting(setting, value)
    subject.stub_chain(:blog_settings, setting).and_return(value)
  end

  def stub_release_file(value)
    fname = File.expand_path("RELEASE_NAME")
    File.stub(:exists?).with(fname).and_return(true)
    File.stub(:read).with(fname).and_return(value)
  end

  def stub_env(env)
    ENV.stub(:[]).with("RACK_ENV").and_return(env)
  end
end
