require "spec_helper"

describe BlogSettings do
  subject { BlogSettings }

  describe "initializer" do
    it "receives a host" do
      expect {
        subject.new("example.com")
      }.to_not raise_error
    end
  end

  describe "#title" do
    context "host is unknown" do
      it "returns default title" do
        subject.new("bla.example.com").title.should be == "my blog"
      end
    end

    context "host is described on settings.yml" do
      it "returns described title" do
        subject.new("other.example.com").title.should be == "my other blog"
      end
    end
  end

  describe "#description" do
    context "host is unknown" do
      it "returns default description" do
        subject.new("bla.example.com").description.should be == "blog description"
      end
    end

    context "host is described on settings.yml" do
      it "returns a described description" do
        subject.new("other.example.com").description.should be == "other blog description"
      end
    end
  end

  describe "#domain" do
    context "host is unknown" do
      it "returns default domain" do
        subject.new("bla.example.com").domain.should be == nil
      end
    end

    context "host is described on settings.yml" do
      it "returns a described domain" do
        subject.new("other.example.com").domain.should be == "other.example.com"
      end
    end
  end

  describe "#home_title" do
    context "host is unknown" do
      it "returns default home_title" do
        subject.new("bla.example.com").home_title.should be == "my blog home page"
      end
    end

    context "host is described on settings.yml" do
      it "returns a described home_title" do
        subject.new("other.example.com").home_title.should be == "my other blog home page"
      end
    end
  end

  describe "#post_title" do
    context "host is unknown" do
      it "returns default post_title" do
        subject.new("bla.example.com").post_title.should be == "%s | my blog"
      end
    end

    context "host is described on settings.yml" do
      it "returns a described post_title" do
        subject.new("other.example.com").post_title.should be == "%s | my other blog"
      end
    end
  end
end
