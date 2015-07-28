FactoryGirl.define do
  factory :blockedversion do
    number "4.1.0"

    association :gemblocker
  end
end