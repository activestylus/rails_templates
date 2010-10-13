git_dir = "http://github.com/activestylus/rails3_mongoid_template/raw/master/"
# #----------------------------------------------------------------------------
# # Bundle Gems
# #----------------------------------------------------------------------------
# puts "=" * 80
# puts "Bundle Gems"
# puts "=" * 80
# run "rvm use #{which_ruby}@#{app_name}"
# run "rvmsudo gem install rake"
# run "rvmsudo gem install bundler"
# run "bundle install"

inside "config" do
  create_file "mongoid.yml", <<-YAML
defaults: &defaults
  host: localhost
  use_object_ids: true

development:
  <<: *defaults
  database: #{app_name}_development
YAML
end

#----------------------------------------------------------------------------
# Setup Compass and RightJS
#----------------------------------------------------------------------------
apply "#{git_dir}actions/setup_compass.rb"
apply "#{git_dir}actions/install_rightjs.rb"

if yes?("Do you need static pages? (y/n)\r\n\r\n=>")
  puts "Generating static pages..."
  generate :controller, "static index"  
  route "map.root :controller => 'static'"
end


#----------------------------------------------------------------------------
# Further Installations
#----------------------------------------------------------------------------
puts "=" * 80
puts "Setup Cucumber"
puts "=" * 80
run "ruby script/generate cucumber"

puts "=" * 80
puts "Generate MongoID Config"
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

puts "=" * 80
puts "Setup Deploy Method"
puts "=" * 80
deploy_method = ask("How will you deploy this app?\r\n\r\n1. Capistrano\r\n2. Heroku\r\n\r\n=>")
if deploy_method == "1"
  puts "Setting up Capistrano..."
  run "capify ."
end
