# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :group, class_name: 'ItemGroup'

  has_one :category, class_name: 'ItemCategory', through: :group, dependent: :restrict_with_exception

  scope :published, -> { where(published: true) }

  delegate :name, to: :category, prefix: true
  delegate :name, to: :group, prefix: true
end
