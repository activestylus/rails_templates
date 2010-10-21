root = "http://github.com/activestylus/rails3_templates/raw/master/"

inside "app/controllers" do
  remove_file "application_controller.rb"
  get "#{root}files/application_controller.rb", "application_controller.rb"
end

inside "config/initializers" do
  get "#{root}files/simple_form.rb", "simple_form.rb"
  get "#{root}files/string.rb", "string.rb"
end

apply "#{root}actions/setup_rvm.rb"
apply "#{root}actions/clear_unnecessary_rails_files.rb"
apply "#{root}actions/add_haml_scaffold.rb"
apply "#{root}actions/add_layout.rb"
apply "#{root}actions/configure_rails.rb"
apply "#{root}actions/setup_default_gems.rb"
apply "#{root}actions/setup_orm.rb"
apply "#{root}actions/install_devise.rb"
apply "#{root}actions/install_prawn.rb"
apply "#{root}actions/setup_compass.rb"
apply "#{root}actions/install_rightjs.rb"

if yes?("Do you want to use CarrierWave for file attachments? (y/n)\r\n\r\n=>")
  puts "\r\n"
  puts "=" * 80
  puts "Installing Carrierwave"
  puts "=" * 80
  gem 'carrierwave', :git => 'git://github.com/jnicklas/carrierwave.git'
  gem 'rmagick', :require => 'RMagick'
  inside "config/initializers" do
    get "#{root}files/carrierwave.rb", "carrierwave.rb"
  end
end

apply  "#{root}actions/setup_environment_gems.rb"


