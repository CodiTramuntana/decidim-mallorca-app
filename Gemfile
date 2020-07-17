# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

# DECIDIM_VERSION = "0.21.0"
DECIDIM_VERSION = { git: 'https://github.com/decidim/decidim.git', branch: '0.21-stable' }

gem "decidim", DECIDIM_VERSION
# gem "decidim-consultations", DECIDIM_VERSION
# gem "decidim-initiatives", DECIDIM_VERSION

gem "bootsnap", "~> 1.3"

gem "puma", "~> 4.3.3"
gem "uglifier", "~> 4.1"

gem "faker", "~> 1.9"

# Keep environment secret variables secret
gem "figaro"
# gem 'whenever', require: false  # esborram!!

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri

  gem "decidim-dev", DECIDIM_VERSION
end

group :development do
  gem "letter_opener_web", "~> 1.3"
  gem "listen", "~> 3.1"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 3.5"

  # Capistrano gems must been installed in each developer RubyGem.
  # For specific versions of Capistrano, uncomment and put the desired
  gem "capistrano", "~> 3.7"
  gem "capistrano-rails", "~> 1.2"
  # gem "capistrano-passenger", "~> 0.2.0"
  gem "capistrano-puma"
  gem "capistrano-yarn"
  #Add this if you"re using rbenv
  gem "capistrano-rbenv", "~> 2.1"
end

# group :production do
#   gem "passenger"
#   gem "delayed_job_active_record"
#   gem "daemons"
# end
