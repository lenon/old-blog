FactoryGirl.define do
  factory :post do
    sequence(:title) { |n| "Post #{n}" }
    sequence(:content) { |n| "This is my post number #{n}" }
    domain "localhost"
  end
end
