#----------------------------------------------------------------------------
# Javascript (RightJS)
#----------------------------------------------------------------------------
puts "=" * 80
puts "Install RightJS"
puts "=" * 80
get "http://rightjs.org/builds/current/right.js.zip", "rightjs.zip"
run "unzip rightjs.zip -d rightjs"
run "mv rightjs/right.js right.js"
run "mv rightjs/right-olds.js right-olds.js"
run "rm -r rightjs"
chosen_widgets = ask("Which RightJS Widgets would you like to use? (answer with array [1,4,5]  \"all\" or press Enter to skip)\r\n\r\n1. Autocompleter\r\n2. Calendar\r\n3. Colorpicker\r\n4. In Place Editor\r\n5. Lightbox\r\n6. Rater\r\n7. Resizable\r\n8. Selectable\r\n9. Slider\r\n10. Tabs\r\n11. Tooltips\r\n12.Uploader\r\n\r\n=>")
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
@import utilities/mixins.sass
@import utilities/constants.sass
@import utilities/form.sass

//--------------------------------------------------------
// Layout
//--------------------------------------------------------
@import text.sass
@import layout.sass

SASS

  unless chosen_widgets == nil
    append_file 'screen.sass', <<-SASS
//--------------------------------------------------------
// RightJS
//--------------------------------------------------------
@import rightjs/selectable.sass
SASS
  end 
end
