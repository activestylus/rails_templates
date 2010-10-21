root = "http://github.com/activestylus/rails_templates/raw/master/"
#----------------------------------------------------------------------------
# Choose ORM
#----------------------------------------------------------------------------
which_orm = ask("Which ORM will you be using?\r\n\r\n1. ActiveRecord\r\n2. Datamapper\r\n3. MongoID\r\n\r\n(Leave blank for ActiveRecord)\r\n\r\n=> ")
if which_orm == "1"
  orm = "active_record"
  railtie = "active_record"
end
if which_orm == "2"
  orm     = "datamapper"
  railtie = "dm-rails"
  puts "=" * 80
  puts "Setting up DM-Rails Identity Map"
  puts "=" * 80
  inject_into_file  'app/controllers/application_controller.rb',
                    "require 'dm-rails/middleware/identity_map'\n",
                    :before => 'class ApplicationController'

  inject_into_class 'app/controllers/application_controller.rb',
                    'ApplicationController',
                    "  use Rails::DataMapper::Middleware::IdentityMap\n"
  puts "=" * 80
  puts "Appending DM gems to Gemfile"
  puts "=" * 80
  append_file 'Gemfile' do
  <<-GEMFILE
  DM_VERSION    = '~> 1.0.2'
  gem 'dm-rails',         '~> 1.0.3'
  gem 'dm-mysql-adapter', DM_VERSION
  gem 'dm-migrations',    DM_VERSION
  gem 'dm-types',         DM_VERSION
  gem 'dm-validations',   DM_VERSION
  gem 'dm-constraints',   DM_VERSION
  gem 'dm-transactions',  DM_VERSION
  gem 'dm-aggregates',    DM_VERSION
  gem 'dm-timestamps',    DM_VERSION
  gem 'dm-observer',      DM_VERSION
  GEMFILE
  end
end
if which_orm == "3"
  orm     = "mongoid"
  railtie = "mongoid"
  puts "=" * 80
  puts "Generating MongoID Config"
  puts "=" * 80
  inside "config" do
    create_file "mongoid.yml", <<-YML
  defaults: &defaults
    host: localhost
    use_object_ids: true

  development:
    <<: *defaults
    database: #{app_name}_development
  YML
  end
  gem 'bson_ext'
  gem 'mongo_session_store', :git => 'git://github.com/mattbeedle/mongo_session_store.git'
  gem 'mongoid', :git => 'git://github.com/mattbeedle/mongoid.git', :branch => 'development'
else
  apply "#{root}actions/configure_db.rb"
end

#----------------------------------------------------------------------------
# Generators
#----------------------------------------------------------------------------
puts "=" * 80
puts "Add generators"
puts "=" * 80
application <<-GENERATORS
    config.generators do |g|
      g.orm :#{orm}
      g.template_engine :haml
      g.test_framework :shoulda, :fixture => false
    end
GENERATORS

#----------------------------------------------------------------------------
# Config
#----------------------------------------------------------------------------
puts "=" * 80
puts "Setup Config"
puts "=" * 80
gsub_file 'config/application.rb', /require 'rails\/all'/ do
<<-END
require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"
require '#{railtie}/railtie'
END
end

#----------------------------------------------------------------------------
# Devise
#----------------------------------------------------------------------------
if yes?("Do you want to install Devise for authentication? (y/n)\r\n=> ")
  puts "\r\n"
  puts "=" * 80
  puts "Installing Devise"
  puts "=" * 80
  gem 'devise', :git => 'git://github.com/plataformatec/devise.git'
  gem 'warden'
  inside "config/initializers" do
    create_file "devise.rb", <<-RB
# Use this hook to configure devise mailer, warden hooks and so forth. The first
# four configuration values can also be set straight in your models.
Devise.setup do |config|
  # Configure the e-mail address which will be shown in DeviseMailer.
  # config.mailer_sender

  # ==> ORM configuration
  # Load and configure the ORM. Supports :active_record (default), :mongoid
  # (bson_ext recommended) and :data_mapper (experimental).
  require 'devise/orm/#{orm}'

  # ==> Configuration for any authentication mechanism
  # Configure which keys are used when authenticating an user. By default is
  # just :email. You can configure it to use [:username, :subdomain], so for
  # authenticating an user, both parameters are required. Remember that those
  # parameters are used only when authenticating and not when retrieving from
  # session. If you need permissions, you should implement that in a before filter.
  # config.authentication_keys = [ :email ]

  # Tell if authentication through request.params is enabled. True by default.
  # config.params_authenticatable = true

  # Tell if authentication through HTTP Basic Auth is enabled. True by default.
  # config.http_authenticatable = true

  # The realm used in Http Basic Authentication
  # config.http_authentication_realm = "Application"

  # ==> Configuration for :database_authenticatable
  # Invoke `rake secret` and use the printed value to setup a pepper to generate
  # the encrypted password. By default no pepper is used.
  # config.pepper = "rake secret output"

  # Configure how many times you want the password re-encrypted. Default is 10.
  config.stretches = 20

  # Define which will be the encryption algorithm. Supported algorithms are :sha1
  # (default), :sha512 and :bcrypt. Devise also supports encryptors from others
  # authentication tools as :clearance_sha1, :authlogic_sha512 (then you should set
  # stretches above to 20 for default behavior) and :restful_authentication_sha1
  # (then you should set stretches to 10, and copy REST_AUTH_SITE_KEY to pepper)
  config.encryptor = :authlogic_sha512

  # ==> Configuration for :confirmable
  # The time you want to give your user to confirm his account. During this time
  # he will be able to access your application without confirming. Default is nil.
  # When confirm_within is zero, the user won't be able to sign in without confirming. 
  # You can use this to let your user access some features of your application 
  # without confirming the account, but blocking it after a certain period 
  # (ie 2 days). 
  # config.confirm_within = 2.days

  # ==> Configuration for :rememberable
  # The time the user will be remembered without asking for credentials again.
  # config.remember_for = 2.weeks

  # ==> Configuration for :validatable
  # Range for password length
  # config.password_length = 6..20

  # Regex to use to validate the email address
  # config.email_regexp = /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i

  # ==> Configuration for :timeoutable
  # The time you want to timeout the user session without activity. After this
  # time the user will be asked for credentials again.
  # config.timeout_in = 10.minutes

  # ==> Configuration for :lockable
  # Defines which strategy will be used to lock an account.
  # :failed_attempts = Locks an account after a number of failed attempts to sign in.
  # :none            = No lock strategy. You should handle locking by yourself.
  # config.lock_strategy = :failed_attempts

  # Defines which strategy will be used to unlock an account.
  # :email = Sends an unlock link to the user email
  # :time  = Re-enables login after a certain amount of time (see :unlock_in below)
  # :both  = Enables both strategies
  # :none  = No unlock strategy. You should handle unlocking by yourself.
  # config.unlock_strategy = :both

  # Number of authentication tries before locking an account if lock_strategy
  # is failed attempts.
  # config.maximum_attempts = 20

  # Time interval to unlock the account if :time is enabled as unlock_strategy.
  # config.unlock_in = 1.hour

  # ==> Configuration for :token_authenticatable
  # Defines name of the authentication token params key
  # config.token_authentication_key = :auth_token

  # ==> Scopes configuration
  # Turn scoped views on. Before rendering "sessions/new", it will first check for
  # "sessions/users/new". It's turned off by default because it's slower if you
  # are using only default views.
  config.scoped_views = true

  # By default, devise detects the role accessed based on the url. So whenever
  # accessing "/users/sign_in", it knows you are accessing an User. This makes
  # routes as "/sign_in" not possible, unless you tell Devise to use the default
  # scope, setting true below.
  # Note that devise does not generate default routes. You also have to
  # specify them in config/routes.rb
  # config.use_default_scope = true

  # Configure the default scope used by Devise. By default it's the first devise
  # role declared in your routes.
  # config.default_scope = :user

  # ==> Navigation configuration
  # Lists the formats that should be treated as navigational. Formats like
  # :html, should redirect to the sign in page when the user does not have
  # access, but formats like :xml or :json, should return 401.
  # If you have any extra navigational formats, like :iphone or :mobile, you
  # should add them to the navigational formats lists. Default is [:html]
  # config.navigational_formats = [:html, :iphone]

  # ==> Warden configuration
  # If you want to use other strategies, that are not (yet) supported by Devise,
  # you can configure them inside the config.warden block. The example below
  # allows you to setup OAuth, using http://github.com/roman/warden_oauth
  #
  # config.warden do |manager|
  #   manager.oauth(:twitter) do |twitter|
  #     twitter.consumer_secret = <YOUR CONSUMER SECRET>
  #     twitter.consumer_key  = <YOUR CONSUMER KEY>
  #     twitter.options :site => 'http://twitter.com'
  #   end
  #   manager.default_strategies(:scope => :user).unshift :twitter_oauth
  # end
end
RB
    gsub_file 'devise.rb', /# config.mailer_sender/ do
      "config.mailer_sender = '#{ask("What email address will this app send mail from?\r\n\r\n=>")}'"
    end
  end
end