if yes?("Do you want to generate PDFs with Prawn? (y/n)\r\n\r\n=>")
  gem 'prawn'
  run 'rvmsudo gem install prawn'
  plugin 'prawnto', :git => 'git://github.com/thorny-sun/prawnto.git'
end