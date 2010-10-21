if yes?("Do you want to install Devise for authentication? (y/n)\r\n=> ")
  puts "\r\n"
  puts "=" * 80
  puts "Installing Devise"
  puts "=" * 80
  gem 'devise', :git => 'git://github.com/plataformatec/devise.git'
  gem 'warden'
  inside "config/initializers" do
    get "#{git_dir}files/devise.rb", "devise.rb"
    gsub_file 'devise.rb', /# config.mailer_sender/ do
      "config.mailer_sender = '#{ask("What email address will this app send mail from?\r\n\r\n=>")}'"
    end
  end
end