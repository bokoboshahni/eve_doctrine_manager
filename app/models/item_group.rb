# frozen_string_literal: true

class ItemGroup < ApplicationRecord
  belongs_to :category, class_name: 'ItemCategory'

  has_many :items, dependent: :destroy, inverse_of: :group, foreign_key: :group_id

  scope :published, -> { where(published: true) }
end
