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