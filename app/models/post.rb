class Post
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps

  field :title
  field :content
  slug :title, :index => true, :permanent => true
  field :published, :type => Boolean, :default => true

  validates_presence_of :title
  validates_presence_of :content
end
