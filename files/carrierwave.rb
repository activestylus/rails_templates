require 'carrierwave/orm/mongoid'

begin
  db_config = YAML::load(File.read(File.join(Rails.root, "/config/mongoid.yml")))
rescue
  raise IOError, 'config/mongoid.yml could not be loaded'
end

CarrierWave.configure do |config|
  config.storage              = :grid_fs
  config.grid_fs_database     = db_config[Rails.env]['database']
  config.grid_fs_access_url   = '/uploads'
  config.grid_fs_host         = db_config[Rails.env]['host']
  config.grid_fs_port         = db_config[Rails.env]['port']
  config.grid_fs_username     = db_config[Rails.env]['username']
  config.grid_fs_password     = db_config[Rails.env]['password']
end