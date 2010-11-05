root = "http://github.com/activestylus/sass_tools/raw/master/"
chosen_widgets = ask("Which RightJS Widgets would you like to use? (answer with array [1,4,5]  \"all\" or press Enter to skip)\r\n\r\n1. Autocompleter\r\n2. Calendar\r\n3. Colorpicker\r\n4.Dialog\r\n5. In Place Editor\r\n6. Lightbox\r\n7. Rater\r\n8. Resizable\r\n9. Selectable\r\n10. Slider\r\n11. Tabs\r\n12. Tooltips\r\n13.Uploader\r\n\r\n=>")
right_widgets = %w(autocompleter calendar colorpicker in-edit lightbox rater resizable selectable slider tabs tooltips uploader)

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