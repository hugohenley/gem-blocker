FactoryGirl.define do
  factory :rubygem do
    name "rails"
    description "Ruby on Rails framework..."
    authors Faker::Name.name
    info "Ruby on Rails is a full-stack web framework optimized for programmer happiness and sustainable productivity."
    current_version "4.2.3"
  end
end