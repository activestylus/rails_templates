create_file 'config/database.yml' do
<<-YAML
defaults: &defaults
  adapter: mysql

development:
  database: #{app_name}_development
  <<: *defaults

  # Add more repositories
  # repositories:
  #   repo1:
  #     adapter:  postgres
  #     database: sample_development
  #     username: the_user
  #     password: secrets
  #     host:     localhost
  #   repo2:
  #     ...

test:
  database: #{app_name}_test
  <<: *defaults
production:
  database: #{app_name}_production
  <<: *defaults
YAML
end