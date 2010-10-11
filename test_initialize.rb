#----------------------------------------------------------------------------
# Gems
#----------------------------------------------------------------------------
puts "=" * 80
puts "Setup Gemfile"
puts "=" * 80
remove_file "Gemfile"
create_file "Gemfile"
gem 'faker'

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
# Bundle Gems
#----------------------------------------------------------------------------
puts "=" * 80
puts "Bundle Gems"
puts "=" * 80
run "rvm use #{which_ruby}@#{app_name}"
run "rvmsudo gem install rake"
run "rvmsudo gem install bundler"
inside app_name do
  run "bundle install"
end