FactoryGirl.define do
  factory :blockedversions do
    version "4.1.0"

    association :gemblocker
  end
end