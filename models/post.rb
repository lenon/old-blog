class Post
  include Mongoid::Document
  include Mongoid::Slug

  field :title
  field :content
  field :published_at
  slug :title
end

