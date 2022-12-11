# frozen_string_literal: true

FactoryBot.define do
  factory :item_category do
    name { Faker::Commerce.department }

    trait :published do
      published { true }
    end

    factory :published_item_category, traits: %i[published]
  end
end
