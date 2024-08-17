# frozen_string_literal: true

ENV["RACK_ENV"] ||= "development"

require "bundler"
Bundler.require(:default, ENV.fetch("RACK_ENV", nil))

loader = Zeitwerk::Loader.new
loader.inflector.inflect("ui" => "UI")
loader.push_dir("lib")
loader.push_dir("app/views")
loader.setup

require_relative "site"
require_relative "routes"
