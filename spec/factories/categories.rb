# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "Категория #{n}" }
    sequence(:slug) { |n| "category-#{n}" }
    sequence(:position) { |n| n }

    trait :with_parent do
      association :parent, factory: :category
    end
  end
end
