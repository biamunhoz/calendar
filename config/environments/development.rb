Rails.application.configure do

  require 'googleauth'
  require 'googleauth/stores/file_token_store'
  #require 'fileutils'

  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join('tmp', 'caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system (see config/storage.yml for options)
  config.active_storage.service = :local

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true

  #tinha desabilitado isso na hora que mandei o email ver se faz diferença
  config.action_mailer.perform_caching = true

  config.action_mailer.perform_deliveries = true

  # config.action_mailer.delivery_method = :smtp
  # config.action_mailer.smtp_settings = {
  #     address: "chagas.icb.usp.br",
  #     port:     25,
  #     domain:   "icb.usp.br"
  # }

  # config.action_mailer.delivery_method = :smtp
  # config.action_mailer.smtp_settings = {
  #   address: ENV["ADDRESSNITRO"],
  #   port:     2525,
  #   domain:   'icb.com.br',
  #   user_name: ENV["USERNITRO"],
  #   password: ENV["SENHANITRO"],
  #   authentication: :login,
  #   enable_starttls_auto: true
  # } 
  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker



#   # Caminho para o client_secret.json e o token salvo
#   client_id_file = Rails.root.join('config/client_secret.json')
#   token_file = Rails.root.join('config/gmail_token.yaml')

#   # Configure o token store
#   token_store = Google::Auth::Stores::FileTokenStore.new(file: token_file)
#   client_id = Google::Auth::ClientId.from_file(client_id_file)
#   user_id = 'default' # o mesmo usado no controller

#   authorizer = Google::Auth::UserAuthorizer.new(client_id, ['https://mail.google.com/'], token_store)
#   credentials = authorizer.get_credentials(user_id)

#   if credentials.nil?
#     puts "[OAuth2] Token não encontrado ou inválido"
#   else
#     config.action_mailer.delivery_method = :smtp
#     config.action_mailer.smtp_settings = {
#       address:              'smtp.gmail.com',
#       port:                 587,
#       domain:               'gmail.com',
#       authentication:       :xoauth2,
#       user_name:            'far...@ic...br',
#       password:             credentials.access_token,
#       enable_starttls_auto: true
#     }
#   end


# require 'google/apis/gmail_v1'
# require 'googleauth'
# require 'googleauth/service_account'

# config.action_mailer.delivery_method = :smtp
# config.action_mailer.smtp_settings = {
#   address: 'smtp.gmail.com',
#   port: 587,
#   domain: 'gmail.com',
#   authentication: :xoauth2,
#   enable_starttls_auto: true,
#   user_name: 'servico-rails@projeto-icb-oauth-rails.iam.gserviceaccount.com', # o email delegado
#     password: lambda {
#       scope = 'https://mail.google.com/'
#       authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
#         json_key_io: File.open('config/projeto-icb-oauth-rails-3b0401af6dc2.json'),
#         scope: scope
#       )
#       authorizer.sub = '' # o mesmo email delegado
#       authorizer.fetch_access_token!
#       authorizer.access_token
#     }.call
#   }

    # require 'yaml'
    # require 'gmail_xoauth'

    # token_path = Rails.root.join('tmp/gmail_token.yaml')
    # access_token = nil

    # if File.exist?(token_path)
    #   token_data = YAML.load_file(token_path)
    #   access_token = token_data['access_token']
    # end

    # config.action_mailer.delivery_method = :smtp
    # config.action_mailer.smtp_settings = {
    #   address:              'smtp.gmail.com',
    #   port:                 587,
    #   domain:               'gmail.com',
    #   user_name:            ''far...@ic...br'',
    #   authentication:       :xoauth2,
    #   oauth2_token:         access_token
    #   #,      enable_starttls_auto: true
    # }



end
