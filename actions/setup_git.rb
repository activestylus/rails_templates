#----------------------------------------------------------------------------
# Setup Git
#----------------------------------------------------------------------------
puts "=" * 80
puts "Setup Git"
puts "=" * 80
remove_file ".gitignore"
get "#{git_dir}files/gitignore", ".gitignore"
git :init
git :add => "."
git :commit => "-a -m 'First commit'"