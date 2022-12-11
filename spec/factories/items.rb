# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    association :group

    name { Faker::Commerce.product_name }

    trait :published do
      published { true }
    end

    factory :published_item, traits: %i[published] do
      association :group, factory: :published_item_group
    end
  end
end
