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

  def on(event_type, &block)
    builder.subscribe(event_type, &block)
  end

  def server_logger
    config.server_logger
  end

  def logger
    config.logger
  end

  def build_path
    config.build_path
  end

  def root_path
    config.root_path
  end

  def resources
    router.resources
  end

  def router
    container[:router]
  end

  def builder
    container[:builder]
  end

  def env
    @env ||= Environment.new container.env
  end

  def container
    Container
  end
end
