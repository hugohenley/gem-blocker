FactoryGirl.define do
  factory :commit do
    hash_id "d179866018c21022006f10061a6db74fe18860ce"
    title "CLOSES #1: Factory Commit"
    author_name Faker::Name.name
    author_email Faker::Internet.email
    commit_created_at Faker::Time.between(DateTime.now - 1, DateTime.now)

    association :project
  end
end