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
      it "returns blog's default home page title" do
        expect(subject.page_title).to eql("home page title")
      end
    end

    context "instance variable @title is set" do
      it "returns blog's post title" do
        subject.instance_variable_set(:@title, "foo bar baz")
        expect(subject.page_title).to be == "foo bar baz | blog post"
      end
    end
  end

  describe "#disqus_shortname" do
    it "returns disqus shortname from settings" do
      expect(subject.disqus_shortname).to be == "example"
    end
  end
end
