# frozen_string_literal: true

require 'omniauth/strategies/eve_online'

OmniAuth.config.logger = Rails.logger

Devise.setup do |config|
  require 'devise/orm/active_record'

  config.timeout_in = 24.hours

  config.omniauth :eve_online,
                  ENV.fetch('ESI_CLIENT_ID', nil),
                  ENV.fetch('ESI_CLIENT_SECRET', nil),
                  strategy_class: OmniAuth::Strategies::EVEOnline,
                  name: :eve
end
