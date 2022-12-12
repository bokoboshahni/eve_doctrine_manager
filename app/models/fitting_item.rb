# frozen_string_literal: true

class FittingItem < ApplicationRecord
  belongs_to :fitting
  belongs_to :item
  belongs_to :charge, class_name: 'Item', optional: true

  enum :location, EVEDoctrineManager::FITTING_LOCATION_TYPES.index_with(&:to_s), prefix: :location
  enum :section, EVEDoctrineManager::FITTING_SECTION_TYPES.index_with(&:to_s), prefix: :section

  validates :location, presence: true, inclusion: { in: EVEDoctrineManager::FITTING_LOCATION_TYPES.map(&:to_s) }
  validates :section, presence: true, inclusion: { in: EVEDoctrineManager::FITTING_SECTION_TYPES.map(&:to_s) }
  validates :position, numericality: { greater_than_or_equal_to: 0 }
  validates :quantity, numericality: { greater_than: 0 }, allow_blank: true

  delegate :category, :category_name, :group, :group_name, :name, to: :item
  delegate :category, :category_name, :group, :group_name, :name, to: :charge, prefix: true
end
