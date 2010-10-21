root = "http://github.com/activestylus/sass_tools/raw/master/"

#----------------------------------------------------------------------------
# Javascript (RightJS)
#----------------------------------------------------------------------------
puts "=" * 80
puts "Install RightJS"
puts "=" * 80
inside "public/javascripts" do
  get "http://rightjs.org/builds/current/right.js.zip", "rightjs.zip"
  run "unzip rightjs.zip -d rightjs"
  run "mv rightjs/right.js right.js"
  run "mv rightjs/right-olds.js right-olds.js"
  run "rm -r rightjs"
  run "rm rightjs.zip"
end
chosen_widgets = ask("Which RightJS Widgets would you like to use? (answer with array [1,4,5]  \"all\" or press Enter to skip)\r\n\r\n1. Autocompleter\r\n2. Calendar\r\n3. Colorpicker\r\n4.Dialog\r\n5. In Place Editor\r\n6. Lightbox\r\n7. Rater\r\n8. Resizable\r\n9. Selectable\r\n10. Slider\r\n11. Tabs\r\n12. Tooltips\r\n13.Uploader\r\n\r\n=>")
right_widgets = %w(autocompleter calendar colorpicker in-edit lightbox rater resizable selectable slider tabs tooltips uploader)
inside "public/javascripts" do
  right_widgets.each do |widget, index|
    unless chosen_widgets == nil
      if chosen_widgets == "all"
        get "http://rightjs.org/builds/ui/right-#{widget}.js", "right-#{widget}.js"
      elsif eval(chosen_widgets).include?(index + 1)
        get "http://rightjs.org/builds/ui/right-#{widget}.js", "right-#{widget}.js"
      end
    end 
  end
end

inside "app/stylesheets" do
  unless chosen_widgets == nil
    append_file 'screen.sass', <<-SASS
//--------------------------------------------------------
// RightJS
//--------------------------------------------------------
@import rightjs/selectable.sass
SASS
  end
end

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
    get "#{root}mixins.sass", "_mixins.sass"
    get "#{root}simple_form.sass", "_simple_form.sass"
    create_file "_constants.sass"
  end
  unless chosen_widgets == nil
    run "mkdir rightjs"
    inside "rightjs" do
      get "#{root}rightjs_selectable.sass", "_selectable.sass"
      # Save this nifty trick for when I complete sass style for all widgets
      # right_widgets.each do |widget, index|
      #   if eval(chosen_widgets).include?(index + 1)
      #     get "#{root}rightjs_#{widget}.sass", "_#{widget}.sass"
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
