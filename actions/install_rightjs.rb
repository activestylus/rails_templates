root = "http://github.com/activestylus/sass_tools/raw/master/"
chosen_widgets = ask("Which RightJS Widgets would you like to use? (answer with array [1,4,5]  \"all\" or press Enter to skip)\r\n\r\n1. Autocompleter\r\n2. Billboard\r\n3. Calendar\r\n4. Colorpicker\r\n5.Dialog\r\n6. In Place Editor\r\n7. Lightbox\r\n8. Rater\r\n9. Resizable\r\n10. Selectable\r\n11. Slider\r\n12. Sortable\r\n13. Tabs\r\n14. Tooltips\r\n15.Uploader\r\n\r\n=>")
right_widgets = %w(autocompleter billboard calendar colorpicker dialog in-edit lightbox rater resizable selectable slider sortable tabs tooltips uploader)

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
  run "mkdir right"
  inside "right" do 
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
end