require_relative "boot"

require "rails"
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"

Bundler.require(*Rails.groups)

module ThanxRewardRedemption
  class Application < Rails::Application
    config.load_defaults 8.0
    config.api_only = true
  end
end