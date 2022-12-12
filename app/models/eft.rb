# frozen_string_literal: true

class EFT
  HEADER_REGEXP = /\[(?<container>[^,]+),\s*(?<name>.+)\]/

  STUB_REGEXP = /^\[.+?\]$/

  MODULE_REGEXP = /^(?<item>[^,\/\[\]]+)(,\s*(?<charge>[^,\/\[\]]+))?(?<offline>\s*\/OFFLINE)?$/

  CARGO_REGEXP = /^(?<item>[^,\/\[\]]+?) x(?<quantity>\d+?)$/

  class Error < StandardError; end

  class InvalidChargeError < Error; end

  class InvalidHeaderError < Error; end

  class InvalidItemError < Error; end

  class FittingSpec
    attr_reader :container, :fitting_name, :sections

    delegate :category_name, :id, :name, to: :container, prefix: true

    def initialize(container_name:, fitting_name:)
      container_name = container_name.strip
      @container = ::Item.find_by(name: container_name)
      raise InvalidItemError, container_name unless @container

      @fitting_name = fitting_name.strip

      @sections = []
    end

    def item_specs
      sections.each_with_object([]) do |section, item_specs|
        item_specs.append(*section.item_specs)
      end
    end
  end

  class ItemSpec
    attr_reader :charge, :item, :offline, :quantity

    attr_accessor :location, :position, :section

    delegate :category_name, :high?, :id, :low?, :medium?, :module?, :name, :rig?, :service?, :subsystem?, to: :item

    def initialize(item_name:, charge_name: nil, quantity: nil, offline: nil)
      item_name = item_name.strip
      @item = ::Item.find_by(name: item_name)
      raise InvalidItemError, item_name unless @item

      if charge_name
        charge_name = charge_name.strip
        @charge = ::Item.find_by(name: charge_name)
        raise InvalidChargeError, charge_name unless @charge
      end

      @offline = offline
      @quantity = quantity
      @location = 'invalid'
    end

    def drone?
      category_name == 'Drone' && cargo?
    end

    def fighter?
      category_name == 'Fighter' && cargo?
    end

    def cargo?
      quantity.present?
    end
  end

  class SectionSpec
    attr_reader :item_specs

    delegate :empty?, to: :item_specs

    def initialize(item_specs)
      @item_specs = item_specs
    end

    def cargo_bay?
      item_specs.compact.all?(&:cargo?)
    end

    def drone_bay?
      item_specs.compact.all?(&:drone?) && item_specs.all?(&:quantity)
    end

    def fighter_bay?
      item_specs.compact.all?(&:fighter?) && item_specs.all?(&:quantity)
    end

    def high?
      item_specs.compact.all?(&:high?) && item_specs.count <= 8
    end

    def low?
      item_specs.compact.all?(&:low?) && item_specs.count <= 8
    end

    def medium?
      item_specs.compact.all?(&:medium?) && item_specs.count <= 8
    end

    def rigs?
      item_specs.compact.all?(&:rig?) && item_specs.count <= 3
    end

    def services?
      item_specs.compact.all?(&:service?) && item_specs.count <= 8
    end

    def subsystems?
      item_specs.compact.all?(&:subsystem?) && item_specs.count <= 4
    end
  end

  def self.import(text)
    raw_lines = text.to_a.map(&:strip)
    header = raw_lines.shift
    lines = raw_lines.split("")

    match = header.match(HEADER_REGEXP)
    raise InvalidHeaderError, header unless match

    fitting = FittingSpec.new(container_name: match[:container], fitting_name: match[:name])

    lines.each do |section_lines|
      item_specs = section_lines.each_with_object([]) do |line, item_specs|
        match = line.match(STUB_REGEXP)
        if match
          item_specs << nil
          next
        end

        match = line.match(CARGO_REGEXP)
        if match
          item_spec = ItemSpec.new(item_name: match[:item], quantity: match[:quantity])
          item_specs << item_spec
          next
        end

        match = line.match(MODULE_REGEXP)
        if match
          item_spec = ItemSpec.new(item_name: match[:item], charge_name: match[:charge], offline: match[:offline])
          item_specs << item_spec
          next
        end
      end

      section = SectionSpec.new(item_specs)
      item_specs.each_with_index do |item_spec, index|
        next if item_spec.blank?

        if section.low?
          item_spec.location = "lo_slot_#{index}"
          item_spec.section = "low"
        elsif section.medium?
          item_spec.location = "med_slot_#{index}"
          item_spec.section = "med"
        elsif section.high?
          item_spec.location = "hi_slot_#{index}"
          item_spec.section = "high"
        elsif section.drone_bay?
          item_spec.location = 'drone_bay'
          item_spec.section = "drone_bay"
        elsif section.rigs?
          item_spec.location = "rig_slot_#{index}"
          item_spec.section = "rigs"
        elsif section.subsystems?
          item_spec.location = "sub_system_slot_#{index}"
          item_spec.section = "sub_systems"
        elsif section.fighter_bay?
          item_spec.location = 'fighter_bay'
          item_spec.section = "fighter_bay"
        elsif section.services?
          item_spec.location = "service_slot_#{index}"
          item_spec.section = "services"
        elsif section.cargo_bay?
          item_spec.location = 'cargo'
          item_spec.section = "cargo"
        else
          item_spec.location = 'invalid'
          item_spec.section = "invalid"
        end

        item_spec.position = index
      end

      fitting.sections << section unless section.empty?
    end

    fitting
  end
end
