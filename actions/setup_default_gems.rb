puts "=" * 80
puts "Setup Gemfile"
puts "=" * 80
remove_file "Gemfile"
create_file "Gemfile"
gem 'compass'
gem 'current', :git => 'git://github.com/activestylus/current.git'
gem 'haml'
gem 'haml-rails'
gem 'has_scope'
gem 'capistrano'
gem 'inherited_resources'
gem 'mime-types'
gem 'rails', '3.0.1'
gem 'simple_form'
gem 'will_paginate', :git => 'git://github.com/mislav/will_paginate.git', :branch => 'rails3'