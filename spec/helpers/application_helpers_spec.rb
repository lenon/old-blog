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
    subject { super().asset_url("bar.css") }

    before do
      Assets.stub(:find_asset).and_return(double(:digest_path => "bar-MYLONGHASH.css"))
    end

    context "production" do

      before { stub_env(:production) }

      it "returns asset url using assets domain" do
        Settings.stub(:assets_domain => "assets.example.com")
        expect(subject).to eql("http://assets.example.com/assets/bar-MYLONGHASH.css")
      end

      it "returns only asset path when assets domain is empty" do
        Settings.stub(:assets_domain => nil)
        expect(subject).to eql("/assets/bar-MYLONGHASH.css")
      end
    end

    context "development" do

      it "returns only asset path" do
        expect(subject).to eql("/assets/bar-MYLONGHASH.css")
      end
    end

    context "missing asset" do

      before do
        Assets.stub(:find_asset).and_return(nil)
      end

      it "raises an error" do
        expect {
          subject
        }.to raise_error("Missing asset: bar.css")
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

  def stub_env(env)
    ENV.stub(:[]).with("RACK_ENV").and_return(env.to_s)
  end
end
