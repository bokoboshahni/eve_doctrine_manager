# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :group, class_name: 'ItemGroup'

  has_one :category, class_name: 'ItemCategory', through: :group, dependent: :restrict_with_exception

  has_many :fitting_versions_as_container,
           class_name: 'FittingVersion',
           foreign_key: :container_id,
           inverse_of: :container,
           dependent: :restrict_with_exception

  has_many :fitting_items, dependent: :restrict_with_exception

  has_many :fitting_versions, through: :fitting_items

  has_many :fittings, through: :fitting_versions

  scope :published, -> { where(published: true) }

  enum :slot, %i[
      low
      medium
      high
      rig
      subsystem
      drone
      fighter
      service
  ].index_with(&:to_s)

  delegate :name, to: :category, prefix: true
  delegate :name, to: :group, prefix: true

  def module?
    MODULE_CATEGORIES.include?(category_name)
  end
end
