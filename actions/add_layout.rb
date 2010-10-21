#----------------------------------------------------------------------------
# Layout
#----------------------------------------------------------------------------
puts "=" * 80
puts "Application Layout"
puts "=" * 80
inside "app/views/layouts" do
  remove_file "application.html.erb"
  get "#{root}files/layout.html.haml", "application.html.haml"
end