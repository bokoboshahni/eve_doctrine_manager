# frozen_string_literal: true

class ItemCategory < ApplicationRecord
  has_many :groups, class_name: 'ItemGroup',
                    foreign_key: :category_id, inverse_of: :category,
                    dependent: :destroy

  has_many :items, through: :groups

  scope :published, -> { where(published: true) }
end
