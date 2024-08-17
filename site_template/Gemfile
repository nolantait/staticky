# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby_version = Pathname.new(__dir__).join(".ruby-version")
ruby ruby_version.read.strip

gem "protos"
gem "protos-icon"
gem "protos-markdown"

gem "dry-inflector"
gem "front_matter_parser"
gem "rack"
gem "rackup"
gem "rake"
gem "rouge"
gem "staticky", github: "nolantait/staticky", branch: "master"
gem "vite_ruby"
gem "zeitwerk"

group :test do
  gem "capybara", require: false
  gem "debug"
  gem "phlex-testing-capybara"
  gem "rspec"
end

group :development do
  gem "rerun"
  gem "rubocop-inhouse", require: false
end
