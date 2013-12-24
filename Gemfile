source 'https://rubygems.org'

gem 'rails', '3.2.11'
gem 'haml-rails'
gem 'bootstrap-sass', '~> 2.2.1.0'
gem 'bootstrap_form'
gem 'bcrypt-ruby', '~> 3.0.0'
gem 'fabrication'
gem 'faker'
gem 'pry'
gem 'strong_parameters'
gem 'jquery-rails', "~> 2.3.0"
gem 'sidekiq'
gem 'unicorn'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

group :development do
  gem 'sqlite3'
  gem 'letter_opener'
end

group :test, :development do
  gem 'rspec-rails'
  gem 'pry'
  gem 'pry-nav'
end

group :test do
  gem 'shoulda-matchers'
  gem 'capybara', '~> 2.1.0'
  gem 'capybara-email', '~> 2.2.0'
  gem 'launchy'
end

group :production do
  gem 'pg'
end