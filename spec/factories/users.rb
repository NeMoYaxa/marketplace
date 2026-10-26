# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:name) { |n| "Пользователь #{n}" }
    password { "password123" }
    password_confirmation { "password123" }
    city { "Москва" }
    phone { "+79991234567" }
    role { :user }
    blocked { false }

    trait :admin do
      role { :admin }
    end

    trait :blocked do
      blocked { true }
    end
  end
end
