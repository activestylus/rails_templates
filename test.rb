#----------------------------------------------------------------------------
# Gems
#----------------------------------------------------------------------------
puts "=" * 80
puts "Setup Gemfile"
puts "=" * 80
remove_file "Gemfile"
create_file "Gemfile"
gem 'will_paginate'
