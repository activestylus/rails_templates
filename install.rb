#----------------------------------------------------------------------------
# Setup RVM
#----------------------------------------------------------------------------
which_ruby = ask("Which rvm Ruby do you want to use?\r\n\r\n=>")
puts "=" * 80
puts "Setup RVM"
puts "=" * 80
run "rvm use #{which_ruby}"
run "rvm gemset create #{app_name}"
create_file ".rvmrc", <<-RVM
rvm use #{which_ruby}@#{app_name}
RVM

#----------------------------------------------------------------------------
# Gather Basic Info
#----------------------------------------------------------------------------
static_pages = yes?("Do you need static pages? (y/n)\r\n\r\n=>")
chosen_auth = ask("Do you want to use authentication\r\n\r\n1. Yes, use Devise\r\n2. No\r\n\r\n=>")
git_dir = "http://github.com/activestylus/rails3_mongoid_template/raw/master/"
tdir = "~/rails3_mongoid_template"

#----------------------------------------------------------------------------
# Cleanup Rails Files
#----------------------------------------------------------------------------
puts "=" * 80
puts "Cleanup Rails Files"
puts "=" * 80
apply "#{git_dir}actions/clear_unnecessary_rails_files.rb"

#----------------------------------------------------------------------------
# Generators
#----------------------------------------------------------------------------
puts "=" * 80
puts "Add generators"
puts "=" * 80
application <<-GENERATORS
    config.generators do |g|
      g.orm :mongoid
      g.template_engine :haml
      g.test_framework :shoulda, :fixture => false
    end
GENERATORS

inside "lib" do
  git :clone => "git@github.com:activestylus/rails3_haml_scaffold_generator.git"
end

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
require 'mongoid/railtie'
END
end

gsub_file 'config/environments/development.rb', /config.action_mailer.raise_delivery_errors = false/ do
  "# config.action_mailer.raise_delivery_errors = false"
end

gsub_file 'config/environments/test.rb', /config.action_mailer.delivery_method = :test/ do
  "# config.action_mailer.delivery_method = :test"
end

inside "app/controllers" do
  remove_file "application_controller.rb"
  get "#{git_dir}files/application_controller.rb", "application_controller.rb"
end

inside "config/initializers" do
  get "#{git_dir}files/simple_form.rb", "simple_form.rb"
  get "#{git_dir}files/string.rb", "string.rb"
end

#----------------------------------------------------------------------------
# Gems
#----------------------------------------------------------------------------
puts "=" * 80
puts "Setup Gemfile"
puts "=" * 80
remove_file "Gemfile"
create_file "Gemfile"
gem 'bson_ext'
gem 'compass'
gem 'current'
if yes?("Do you want to use CarrierWave for file attachments? (y/n)\r\n\r\n=>")
  gem 'carrierwave', :git => 'git://github.com/jnicklas/carrierwave.git'
  gem 'rmagick', :require => 'RMagick'
  inside "config/initializers" do
    get "#{git_dir}files/carrierwave.rb", "carrierwave.rb"
  end
end
if chosen_auth=="1"
  gem 'devise', :git => 'git://github.com/plataformatec/devise.git'
  gem 'warden'
  inside "config/initializers" do
    get "#{git_dir}files/devise.rb", "devise.rb"
    gsub_file 'devise.rb', /# config.mailer_sender/ do
      "config.mailer_sender = '#{ask("What email address will this app send mail from?\r\n\r\n=>")}'"
    end
  end
end
gem 'haml'
gem 'haml-rails'
gem 'has_scope'
if deploy_method == "1"
  gem 'capistrano'
elsif deploy_method == "2"
  gem 'heroku'
  gem 'heroku-autoscale', :require => 'heroku/autoscale'
end
gem 'inherited_resources'
gem 'mongo_session_store', :git => 'git://github.com/mattbeedle/mongo_session_store.git'
gem 'mongoid'
gem 'mime-types'
if yes?("Do you want to print PDFs? (y/n)\r\n\r\n=>")
  gem 'prawn'
  run 'rvmsudo gem install prawn'
  plugin 'prawnto', :git => 'git://github.com/thorny-sun/prawnto.git'
end
gem 'rails'
gem 'simple_form'
gem 'will_paginate', :git => 'git://github.com/mislav/will_paginate.git'

append_file "Gemfile", <<-GEM

group :production do
  gem 'smurf'
end

group :development do
  gem 'htmlentities'
  gem 'wirble'
end

group :test do
  gem 'autotest-rails', :require => 'autotest/rails'
  gem 'autotest-notification'
  gem 'capybara'
  gem 'cucumber'
  gem 'cucumber-rails'
  gem 'database_cleaner'
  gem 'faker'
  gem 'fakeweb'
  gem 'launchy'
  gem 'machinist_mongo', :require => 'machinist/mongoid'
  gem 'mocha'
  gem 'pickle', '0.2.11'
  gem 'rcov'
  gem 'redgreen'
  gem 'shoulda'
  gem 'spork'
end
GEM

#----------------------------------------------------------------------------
# Layout
#----------------------------------------------------------------------------
puts "=" * 80
puts "Application Layout"
puts "=" * 80
inside "app/views/layouts" do
  remove_file "application.html.erb"
  get "#{git_dir}files/layout.html.haml", "application.html.haml"
end

if static_pages
  puts "Generating static pages..."
  generate :controller, "static index"  
  route "map.root :controller => 'static'"
end

#----------------------------------------------------------------------------
# Setup Git
#----------------------------------------------------------------------------
puts "=" * 80
puts "Setup Git"
puts "=" * 80
get "#{git_dir}files/gitignore", ".gitignore"
git :init
git :add => "."
git :commit => "-a -m 'First commit'"