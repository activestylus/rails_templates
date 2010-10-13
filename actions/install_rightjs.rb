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