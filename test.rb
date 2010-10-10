#----------------------------------------------------------------------------
# Gather Basic Info
#----------------------------------------------------------------------------
which_ruby = ask("Which rvm Ruby do you want to use?\r\n\r\n=>")

#----------------------------------------------------------------------------
# Setup RVM
#----------------------------------------------------------------------------
puts "=" * 80
puts "Setup RVM"
puts "=" * 80
run "rvm use #{which_ruby}"
run "rvm gemset create #{app_name}"
create_file ".rvmrc", <<-RVM
rvm use #{which_ruby}@#{app_name}
RVM
run "rvm use #{which_ruby}@#{app_name}"
run "rvmsudo gem install rake"
run "rvmsudo gem install bundler"
run "rvmsudo gem install rails"

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
run "bundle install"