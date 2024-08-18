# frozen_string_literal: true

require "./config/boot"
Bundler.require(:test)

require "capybara/rspec"
require "phlex/testing/capybara"
require "dry/inflector"

inflector = Dry::Inflector.new

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  %w[views].each do |type|
    config.define_derived_metadata(file_path: %r{spec/#{type}}) do |metadata|
      metadata[:type] ||= inflector.singularize(type).to_sym
    end
  end

  config.include Phlex::Testing::Capybara::ViewHelper, type: :view
end
