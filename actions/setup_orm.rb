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