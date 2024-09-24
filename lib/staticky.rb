# frozen_string_literal: true

require "uri"
require "delegate"

require "phlex"
require "dry/container"
require "dry/system"
require "dry/configurable"
require "dry/logger"
require "tilt"
require "staticky-files"

module Staticky
  GEM_ROOT = Pathname.new(__dir__).join("..").expand_path
end

require_relative "staticky/pluggable"
require_relative "staticky/resources/plugins"
require_relative "staticky/resources/plugins/prelude"
require_relative "staticky/resources/plugins/phlex"
require_relative "staticky/routing/plugins"
require_relative "staticky/routing/plugins/prelude"
require_relative "staticky/application"

module Staticky
  # DOCS: Module for static site infrastructure such as:
  # - Defining routes
  # - Compiling templates
  # - Development server
  # - Managing filesystem

  module_function

  extend Dry::Configurable

  setting :env, default: ENV.fetch("RACK_ENV", "development").to_sym
  setting :build_path, default: Pathname.new("build")
  setting :root_path, default: Pathname(__dir__)
  setting :logger, default: Dry.Logger(:staticky, template: :details)
  setting :server_logger, default: Dry.Logger(
    :staticky_server,
    template: :details,
    formatter: :rack
  )

  def monitor(...) = application.monitor(...)
  def server_logger = config.server_logger
  def logger = config.logger
  def build_path = config.build_path
  def root_path = config.root_path
  def resources = router.resources
  def router = application[:router]
  def builder = application[:builder]
  def generator = application[:generator]
  def application = Application

  def env
    Environment.new config.env.to_sym
  end
end
