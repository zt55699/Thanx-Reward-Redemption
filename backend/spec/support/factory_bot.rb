FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@thanx.com" }
    name { "Test User" }
    password { "password123" }
    admin { false }
    points_balance { 1000 }

    trait :admin do
      admin { true }
    end
  end

  factory :reward do
    name { "Test Reward" }
    description { "A test reward description" }
    cost { rand(100..1000) }
  end

  factory :redemption do
    user
    reward
  end
end