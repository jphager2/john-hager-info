require File.expand_path('../boot', __FILE__)

require 'rails/all'
require_relative '../app/middleware/github_backend'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module JohnHager
  class Application < Rails::Application

    config.middleware.delete(Rack::Lock)
    config.middleware.use(JohnHager::GithubBackend)

    config.assets.precompile += ['application.css', 'pages.css', 'foundation_and_overrides.scss', 'fonts.css'] 

    config.active_record.raise_in_transactional_callbacks = true

    ActiveSupport.halt_callback_chains_on_return_false = false
  end
end

