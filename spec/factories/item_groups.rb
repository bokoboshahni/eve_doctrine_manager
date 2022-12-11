# frozen_string_literal: true

FactoryBot.define do
  factory :item_group do
    association :category

    name { Faker::Commerce.department }

    trait :published do
      published { true }
    end

    factory :published_item_group, traits: %i[published] do
      association :category, factory: :published_item_category
    end
  end
end
