require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module FiveMinFullcalendar
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'environment_variables.yml')
      YAML.load(File.open(env_file)).each do |key, value|
        ENV[key.to_s] = value
      end if File.exists?(env_file)
    end

    #config.time_zone = 'Eastern Time (US & Canada)'
    #config.active_record.default_timezone = :local  

    #config.time_zone = 'Brasilia'
    #config.active_record.default_timezone = 'Brasilia'
    
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales','**', '*.{rb,yml}').to_s]
    config.i18n.available_locales= [:en, 'pt-BR']

    config.i18n.default_locale = "pt-BR"


    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
