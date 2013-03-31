require "spec_helper"

describe Post do
  it { should respond_to :title }
  it { should respond_to :content }
  it { should respond_to :slug }
  it { should respond_to :domain }

  it "should not be saved" do
    Post.new.save.should be_false
  end

  it "should be created" do
    Post.create!({
      :title => "Foo",
      :content => "Bar"
    }).should be_true
  end

  it "must have a title" do
    Post.new({
      :content => "bla"
    }).should_not be_valid
  end

  it "must have content" do
    Post.new({
      :title => "foo"
    }).should_not be_valid
  end

  it "must have a unique slug" do
    first = Post.create!({
      :title => "foo",
      :content => "bar"
    })

    second = Post.create!({
      :title => "foo",
      :content => "bar"
    })

    first.slug.should_not == second.slug
  end

  specify "by default domain must be Setting.default_domain" do
    Settings.stub(:default_domain => "foo.com.br")
    Post.new.domain.should be == "foo.com.br"
  end

  it "validates inclusion of domain in Setting.domains" do
    Settings.stub(:domains => %w(foo.com.br bar.com.br))
    post = Post.new(:domain => "foobar")

    post.should_not be_valid
    post.errors[:domain].should include "is not included in the list"
  end

  it "saves a Post with valid domain" do
    Settings.stub(:domains => ["risos.com.br"])
    post = Post.new({
      :title => "risos",
      :content => "Foobarbaz",
      :domain => "risos.com.br"
    })

    expect { post.save! }.to_not raise_error
  end
end
