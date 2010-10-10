#----------------------------------------------------------------------------
# Bundle Gems
#----------------------------------------------------------------------------
puts "=" * 80
puts "Bundle Gems"
puts "=" * 80
run "rvm use #{which_ruby}@#{app_name}"
run "rvmsudo gem install rake"
run "rvmsudo gem install bundler"
run "bundle install"

#----------------------------------------------------------------------------
# Setup Compass and RightJS
#----------------------------------------------------------------------------
apply "#{git_dir}actions/setup_compass_and_rightjs.rb"

#----------------------------------------------------------------------------
# Further Installations
#----------------------------------------------------------------------------
if yes?("Do you want to print PDFs? (y/n)\r\n\r\n=>")
  gem 'mime-types'
  gem 'prawn'
  run 'rvmsudo gem install prawn'
  plugin 'prawnto', :git => 'git://github.com/thorny-sun/prawnto.git'
end
puts "=" * 80
puts "Setup Cucumber"
puts "=" * 80
run "ruby script/generate cucumber"
run "rails generate mongoid:config"

deploy_method = ask("How will you deploy this app?\r\n\r\n1. Capistrano\r\n2. Heroku\r\n\r\n=>")
if deploy_method == "1"
  puts "Setting up Capistrano..."
  run "capify ."
end
if static_pages
  puts "Generating static pages..."
  generate :controller, "static index"  
  route "map.root :controller => 'static'"
end