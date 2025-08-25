source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

gem 'i18n-tasks'
gem 'money-rails'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 6.3'
gem 'rails', '~> 7.0.8'
gem 'scenic', '~> 1.7'
gem 'sprockets-rails'
gem 'turbo-rails'
gem 'webpacker', '~> 5.4.4'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails'
end

group :development do
  gem 'listen', '~> 3.2'
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'importmap-rails', '~> 1.2'
