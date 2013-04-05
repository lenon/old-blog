require "spec_helper"

describe Helpers do
  subject do
    klass = Class.new { include Helpers }
    klass.new
  end

  describe "#site_title" do
    before do
      subject.stub_chain(:request, :env).and_return(env)
    end

    context "HTTP_HOST is empty" do
      let(:env) { {} }

      it "returns the title set for default domain in settings.yml" do
        subject.site_title.should be == "My Blog"
      end
    end

    context "HTTP_HOST is an unknown domain" do
      let(:env) { { "HTTP_HOST" => "missing.example.com" } }

      it "returns the title set for default domain in settings.yml" do
        subject.site_title.should be == "My Blog"
      end
    end

    context "HTTP_HOST is a known domain" do
      let(:env) { { "HTTP_HOST" => "other.example.com" } }

      it "returns the title set for the given host in settings.yml" do
        subject.site_title.should be == "My Other Blog"
      end
    end
  end

  describe "#site_description" do
    before do
      subject.stub_chain(:request, :env).and_return(env)
    end

    context "HTTP_HOST is empty" do
      let(:env) { {} }

      it "returns the description set for default domain in settings.yml" do
        subject.site_description.should be == "My Blog Description"
      end
    end

    context "HTTP_HOST is an unknown domain" do
      let(:env) { { "HTTP_HOST" => "missing.example.com" } }

      it "returns the description set for default domain in settings.yml" do
        subject.site_description.should be == "My Blog Description"
      end
    end

    context "HTTP_HOST is a known domain" do
      let(:env) { { "HTTP_HOST" => "other.example.com" } }

      it "returns the description set for the given host in settings.yml" do
        subject.site_description.should be == "My Other Blog Description"
      end
    end
  end

  describe "#asset" do
    context "RACK_ENV is production" do
      let(:release_file) { File.expand_path("RELEASE_NAME") }

      it "returns Setting.assets_domain + RELEASE_NAME + source path" do
        File.should_receive(:exists?).with(release_file).and_return(true)
        File.should_receive(:read).with(release_file).and_return("RELEASE-TIMESTAMP\n")
        ENV.stub(:[] => "production")

        subject.asset("/foo/bar.css").should be == "http://assets.example.com/RELEASE-TIMESTAMP/foo/bar.css"
      end
    end

    context "RACK_ENV is not production" do
      it "returns source path" do
        ENV.stub(:[] => "test")
        subject.asset("/foo/bar.css").should be == "/foo/bar.css"
      end
    end
  end
end
