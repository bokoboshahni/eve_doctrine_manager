# frozen_string_literal: true

class Fitting < ApplicationRecord
  belongs_to :container, class_name: 'Item'

  has_many :fitting_items, dependent: :destroy
  has_many :items, through: :fitting_items

  has_one :group, class_name: 'ItemGroup', through: :container
  has_one :category, class_name: 'ItemCategory', through: :group

  delegate :name, to: :category, prefix: true
  delegate :name, to: :group, prefix: true
  delegate :name, to: :container, prefix: true

  validates :fitting_name, presence: true, uniqueness: { scope: :container_id }

  accepts_nested_attributes_for :fitting_items

  def self.from_eft(text)
    spec = EFT.import(text)
    fitting = find_or_create_by!(container_id: spec.container_id, fitting_name: spec.fitting_name)

    fitting_items = spec.item_specs.each_with_object([]) { |spec, items|
      next if spec.blank?
      items << {
        item: spec.item,
        charge: spec.charge,
        location: spec.location.to_sym,
        position: spec.position,
        section: spec.section.to_sym,
        offline: spec.offline,
        quantity: spec.quantity
      }
    }
    fitting.fitting_items.destroy_all
    fitting.update!(fitting_items_attributes: fitting_items)
  end

  def to_eft
    order = EVEDoctrineManager::FITTING_SECTION_TYPES.map(&:to_s)
    items = fitting_items.order(:position).group_by(&:section)
    sections = order.each_with_object([]) do |section, lines|
      next if container.category_name == 'Ship' && section == 'services'
      next unless items[section]

      items[section]&.each do |item|
        str = item.name
        str += " x#{item.quantity}" if item.quantity
        str += ", #{item.charge_name}" if item.charge
        str += " /OFFLINE" if item.offline?
        lines << str
      end
      lines << "\n"
    end
    sections.unshift("[#{container_name}, #{fitting_name}]\n")
    sections.join("\n")
  end
end
