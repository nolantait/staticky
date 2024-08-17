# frozen_string_literal: true

require "phlex"
require "dry/system"
require "dry/configurable"

require_relative "staticky/container"

module Staticky
  # DOCS: Module for static site infrastructure such as:
  # - Defining routes
  # - Compiling templates
  # - Development server
  # - Managing filesystem

  module_function

  extend Dry::Configurable

  setting :build_path, default: Pathname.new("build")
  setting :root_path, default: Pathname(__dir__)
  setting :logger, default: Logger.new($stdout)
  setting :env, default: :development

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

  def env
    @env ||= Environment.new container.env
  end

  def container
    Container
  end
end
