remove_file 'README'
remove_file 'config/database.yml.example'
remove_file 'config/database.yml'
remove_file 'public/index.html'
remove_file 'public/favicon.ico'
remove_file 'public/images/rails.png'
create_file 'README.textile'
run "rm public/javascripts/*.js"