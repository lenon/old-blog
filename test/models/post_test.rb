require "test/helper"

class PostTest < Test::Unit::TestCase
  def setup
    Post.delete_all
  end

  def test_post_expected_attributes
    assert(Post.new.respond_to?(:title))
    assert(Post.new.respond_to?(:content))
    assert(Post.new.respond_to?(:slug))
  end

  def test_post_without_any_attributes
    assert(!Post.new.valid?)
  end

  def test_post_without_title
    post = Post.new({
      :content => "bla"
    })
    assert(!post.valid?)
  end

  def test_post_without_content
    post = Post.new({
      :title => "foo"
    })
    assert(!post.valid?)
  end

  def test_post_creation
    assert_nothing_raised do
      Post.create!({
        :title => "Foo",
        :content => "Bar"
      })
    end
  end

  def test_unique_slug
    first_post = Post.create!({
      :title => "foo",
      :content => "bar"
    })
    second_post = Post.create!({
      :title => "foo",
      :content => "bar"
    })
    assert_not_equal(first_post.slug, second_post.slug)
  end

  def test_excerpt
    post = Post.create!({
      :title => "test",
      :content => "bla"
    })
    assert_equal("bla", post.excerpt)
  end
end
