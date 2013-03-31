class Post
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps

  field :title
  field :content
  field :domain, :default => lambda { |*| Settings.default_domain }
  slug :title, :index => true, :permanent => true

  validates_presence_of :title
  validates_presence_of :content
  validates_inclusion_of :domain, :in => lambda { |*| Settings.domains }
end
