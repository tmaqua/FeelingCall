source 'https://rubygems.org'

ruby '2.2.0'

gem 'rails', '4.2.3'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'therubyracer', platforms: :ruby

gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc
# gem 'unicorn'
# Use Puma as the app server
gem 'puma'

gem 'slim-rails'
gem 'twilio-ruby'
gem 'grape'
gem 'grape-jbuilder'

gem 'config'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development do
  gem 'sqlite3'
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
end

group :development, :test do
  gem 'byebug'
  gem 'web-console', '~> 2.0'
  gem 'spring'
  gem 'json_expressions'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
end

