# frozen_string_literal: true

module EVEDoctrineManager
  # rubocop:disable Naming/VariableNumber
  FITTING_LOCATION_TYPES = %i[
    invalid
    cargo
    lo_slot_0
    lo_slot_1
    lo_slot_2
    lo_slot_3
    lo_slot_4
    lo_slot_5
    lo_slot_6
    lo_slot_7
    med_slot_0
    med_slot_1
    med_slot_2
    med_slot_3
    med_slot_4
    med_slot_5
    med_slot_6
    med_slot_7
    hi_slot_0
    hi_slot_1
    hi_slot_2
    hi_slot_3
    hi_slot_4
    hi_slot_5
    hi_slot_6
    hi_slot_7
    drone_bay
    rig_slot_0
    rig_slot_1
    rig_slot_2
    sub_system_slot_0
    sub_system_slot_1
    sub_system_slot_2
    sub_system_slot_3
    fighter_bay
    service_slot_0
    service_slot_1
    service_slot_2
    service_slot_3
    service_slot_4
    service_slot_5
    service_slot_6
    service_slot_7
  ].freeze
  # rubocop:enable Naming/VariableNumber

  FITTING_SECTION_TYPES = %i[
    low
    med
    high
    drone_bay
    rigs
    sub_systems
    fighter_bay
    services
    cargo
    invalid
  ]
end
