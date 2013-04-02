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
end
