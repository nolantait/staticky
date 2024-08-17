# frozen_string_literal: true

require "phlex"
require "dry/system"
require "dry/configurable"
require "dry/logger"

require_relative "staticky/container"

module Staticky
  # DOCS: Module for static site infrastructure such as:
  # - Defining routes
  # - Compiling templates
  # - Development server
  # - Managing filesystem

  module_function

  extend Dry::Configurable

  setting :env, default: :development
  setting :build_path, default: Pathname.new("build")
  setting :root_path, default: Pathname(__dir__)
  setting :logger, default: Dry.Logger(:staticky, template: :details)
  setting :server_logger, default: Dry.Logger(
    :staticky_server,
    template: :details,
    formatter: :rack
  )

  def monitor(...) = container.monitor(...)
  def on(event_type, &block) = builder.subscribe(event_type, &block)
  def server_logger =config.server_logger
  def logger = config.logger
  def build_path = config.build_path
  def root_path = config.root_path
  def resources = router.resources
  def router = container[:router]
  def builder = container[:builder]
  def container = Container

  def env
    @env ||= Environment.new container.env
  end
end
