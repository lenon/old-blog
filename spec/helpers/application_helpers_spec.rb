require "spec_helper"

describe ApplicationHelpers do

  subject do
    Class.new { include ApplicationHelpers }.new
  end

  before do
    subject.stub(:request => double(:env => {}))
  end

  describe "#current_user" do
    context "there is an admin logged in" do
      let(:admin) { create(:admin) }

      it "returns this admin" do
        subject.stub(:session => { :admin_id => admin.id })
        expect(subject.current_user).to eql(admin)
      end
    end

    context "there is not and admin logged in" do
      before do
        subject.stub(:session => { :admin_id => nil })
      end

      it "returns false" do
        expect(subject.current_user).to be(false)
      end
    end
  end

  describe "#blog_title" do
    before { stub_blog_setting(:title => "blog title") }

    it "returns blog's title" do
      expect(subject.blog_title).to be == "blog title"
    end
  end

  describe "#blog_description" do
    before { stub_blog_setting(:description => "blog description") }

    it "returns blog's description" do
      expect(subject.blog_description).to be == "blog description"
    end
  end

  describe "#blog_domain" do
    before { stub_blog_setting(:domain => "example.com") }

    it "returns blog's domain" do
      expect(subject.blog_domain).to be == "example.com"
    end
  end

  describe "#page_title" do

    context "instance variable @title is not set" do
      before { stub_blog_setting(:home_title => "home page title") }

      it "returns blog's default home page title" do
        expect(subject.page_title).to eql("home page title")
      end
    end

    context "instance variable @title is set" do
      before { stub_blog_setting(:post_title => "%s | blog post") }

      it "returns blog's post title" do
        subject.instance_variable_set(:@title, "foo bar baz")
        expect(subject.page_title).to be == "foo bar baz | blog post"
      end
    end
  end

  describe "#asset_url" do
    after { ENV["RACK_ENV"] = "test" }

    context "missing asset" do
      it "raises an error" do
        expect {
          subject.asset_url("risos.css")
        }.to raise_error("Missing asset: risos.css")
      end
    end

    context "production environment" do
      before do
        ENV["RACK_ENV"] = "production"
        Assets::Manifest.any_instance.stub(:assets => { "risos.css" => "risos-mylonghash.css" })
      end

      it "returns an url with assets domain and compiled hash" do
        expect(subject.asset_url("risos.css")).to eql("http://assets.example.com/assets/risos-mylonghash.css")
      end
    end

    context "development environment" do
      before do
        ENV["RACK_ENV"] = "development"
        Assets::Environment.any_instance.stub(:find_asset => double(:digest_path => "risos-mylonghash.css"))
      end

      it "only returns assets path with file name and hash" do
        expect(subject.asset_url("risos.css")).to eql("/assets/risos-mylonghash.css")
      end
    end
  end

  def stub_blog_setting(*args)
    BlogSettings.stub(:from_cache => double(*args))
  end
end
