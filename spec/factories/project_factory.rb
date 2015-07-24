FactoryGirl.define do
  factory :project do
    sequence(:name) { |n| "Project #{n}" }
    ssh_url_to_repo "Doe"
    http_url_to_repo "Doe"
    sequence(:gitproject_id) { |n| n }
    description "Description of a project goes here..."
  end
end