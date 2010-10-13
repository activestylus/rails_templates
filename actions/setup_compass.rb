#----------------------------------------------------------------------------
# Setup Compass
#----------------------------------------------------------------------------
puts "=" * 80
puts "Setup Compass"
puts "=" * 80
inside "config" do
  create_file "compass.rb", <<-RB
# Require any additional compass plugins here.
project_type = :rails
project_path = Rails.root if defined?(Rails.root)
# Set this to the root of your project when deployed:
http_path = "/"
css_dir = "public/stylesheets"
sass_dir = "app/stylesheets"
# To enable relative paths to assets via compass helper functions. Uncomment:
# relative_assets = true
RB
end

#----------------------------------------------------------------------------
# Install Style Goodies
#----------------------------------------------------------------------------
puts "=" * 80
puts "Install Sass Tools"
puts "=" * 80
run "mkdir app/stylesheets"
inside "app/stylesheets" do
  puts "Downloading Sass tools..."
  run "mkdir tools"
  inside "tools" do
    get "http://github.com/activestylus/sass_tools/raw/master/mixins.sass", "_mixins.sass"
    get "http://github.com/activestylus/sass_tools/raw/master/simple_form.sass", "_simple_form.sass"
    create_file "_constants.sass"
  end
  unless chosen_widgets == nil
    run "mkdir rightjs"
    inside "rightjs" do
      get "http://github.com/activestylus/sass_tools/raw/master/rightjs_selectable.sass", "_selectable.sass"
      # Save this nifty trick for when I complete sass style for all widgets
      # right_widgets.each do |widget, index|
      #   if eval(chosen_widgets).include?(index + 1)
      #     get "http://github.com/activestylus/sass_tools/raw/master/rightjs_#{widget}.sass", "_#{widget}.sass"
      #   end
      # end
    end
  end
  create_file "_layout.sass"
  create_file "_text.sass"
  create_file "screen.sass", <<-SASS
//--------------------------------------------------------
// Utilities
//--------------------------------------------------------
@import compass/reset
@import tools/mixins.sass
@import tools/constants.sass
@import tools/simple_form.sass

//--------------------------------------------------------
// Layout
//--------------------------------------------------------
@import text.sass
@import layout.sass

SASS
end
