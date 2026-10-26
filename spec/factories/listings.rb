# frozen_string_literal: true

FactoryBot.define do
  factory :listing do
    association :user
    association :category
    sequence(:title) { |n| "Объявление #{n}" }
    description { "Описание объявления" }
    price { 10_000 }
    city { "Москва" }
    status { :active }

    trait :sold do
      status { :sold }
    end

    trait :archived do
      status { :archived }
    end

    trait :with_images do
      after(:build) do |listing|
        next if listing.images.attached?

        listing.images.attach(
          io: Rails.root.join("spec/fixtures/files/small.png").open,
          filename: "small.png",
          content_type: "image/png"
        )
      end
    end
  end
end
