class Post
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps

  field :title
  field :content
  slug :title

  validates_presence_of :title
  validates_presence_of :content
  validates_presence_of :slug
end
