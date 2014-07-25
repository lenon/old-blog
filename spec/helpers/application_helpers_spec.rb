require "spec_helper"

describe ApplicationHelpers do

  subject do
    Class.new { include ApplicationHelpers }.new
  end

  before do
    subject.stub(:request => double(:env => {}))
  end

  describe "#current_admin" do
    context "there is an admin logged in" do
      let(:admin) { create(:admin) }

      it "returns this admin" do
        subject.stub(:session => { :admin_id => admin.id })
        expect(subject.current_admin).to eql(admin)
      end
    end

    context "there is not and admin logged in" do
      before do
        subject.stub(:session => { :admin_id => nil })
      end

      it "returns false" do
        expect(subject.current_admin).to be(false)
      end
    end
  end

  describe "#blog_title" do
    it "returns blog's title" do
      expect(subject.blog_title).to be == "blog title"
    end
  end

  describe "#blog_description" do
    it "returns blog's description" do
      expect(subject.blog_description).to be == "blog description"
    end
  end

  describe "#page_title" do

    context "instance variable @title is not set" do
      it "returns blog's title" do
        expect(subject.page_title).to eql("blog title")
      end
    end

    context "instance variable @title is set" do
      it "returns blog's title and page's title" do
        subject.instance_variable_set(:@title, "foo bar baz")
        expect(subject.page_title).to be == "foo bar baz | blog title"
      end
    end
  end

  describe "#disqus_shortname" do
    it "returns disqus shortname from settings" do
      expect(subject.disqus_shortname).to be == "example"
    end
  end

  describe "#gravatar_url" do
    it "returns the gravatar picture url" do
      expect(subject.gravatar_url).to be =~ /7daf6c79d4802916d83f6266e24850af/
    end
  end

  describe "#author_name" do
    it "returns the author name" do
      expect(subject.author_name).to be == "blog author"
    end
  end

  describe "#author_bio" do
    it "returns the author bio" do
      expect(subject.author_bio).to be == "author bio"
    end
  end

  describe "#analytics_ua" do
    it "returns the google analytics UA code" do
      expect(subject.analytics_ua).to be == "UA-XXXXXXXX-X"
    end
  end
end
