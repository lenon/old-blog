require "spec_helper"

describe BlogSettings do
  subject { described_class }

  describe ".from_cache" do
    context "two different hosts" do
      it "returns two different instances" do
        default = subject.from_cache("defaultblog.com")
        other   = subject.from_cache("other.example.com")

        expect(default).to be_kind_of(BlogSettings)
        expect(other).to_not eql(default)
      end
    end

    context "two equal hosts" do
      it "returns the same instance" do
        default = subject.from_cache("defaultblog.com")
        other   = subject.from_cache("defaultblog.com")

        expect(default).to be_kind_of(BlogSettings)
        expect(other).to eql(default)
      end
    end
  end

  describe "#title" do
    context "host is not described in settings.yml" do
      it "returns the default title" do
        subject.new("bla.example.com").title.should eql("default blog")
      end
    end

    context "host is described in settings.yml" do
      it "returns the described title" do
        subject.new("other.example.com").title.should eql("my other blog")
      end
    end
  end

  describe "#description" do
    context "host is not described in settings.yml" do
      it "returns the default description" do
        subject.new("bla.example.com").description.should eql("default blog description")
      end
    end

    context "host is described in settings.yml" do
      it "returns the described description" do
        subject.new("other.example.com").description.should eql("other blog description")
      end
    end
  end

  describe "#domain" do
    context "host is not described in settings.yml" do
      it "returns the default domain" do
        subject.new("bla.example.com").domain.should eql("defaultblog.com")
      end
    end

    context "host is described in settings.yml" do
      it "returns the described domain" do
        subject.new("other.example.com").domain.should eql("other.example.com")
      end
    end
  end

  describe "#home_title" do
    context "home_title is not described in settings.yml" do
      it "returns the default home_title" do
        subject.new("bla.example.com").home_title.should eql("default blog home page")
      end
    end

    context "host is described in settings.yml" do
      it "returns the described home_title" do
        subject.new("other.example.com").home_title.should eql("my other blog home page")
      end
    end
  end

  describe "#post_title" do
    context "post_title is not described in settings.yml" do
      it "returns the default post_title" do
        subject.new("bla.example.com").post_title.should eql("%s | default blog")
      end
    end

    context "host is described in settings.yml" do
      it "returns the described post_title" do
        subject.new("other.example.com").post_title.should eql("%s | my other blog")
      end
    end
  end
end
