# frozen_string_literal: true

require "phlex"
require "dry/system"

require_relative "staticky/error"
require_relative "staticky/version"
require_relative "staticky/environment"
require_relative "staticky/router"
require_relative "staticky/filesystem"
require_relative "staticky/container"
require_relative "staticky/resource"
require_relative "staticky/builder"

module Staticky
  module_function

  # DOCS: Module for static site infrastructure such as:
  # - Defining routes
  # - Compiling templates
  # - Development server
  # - Managing filesystem

  def configure
    yield(container.config)
  end

  def files
    container[:files]
  end

  def build_path
    container.config.build_path
  end

  def root_path
    container.config.root_path
  end

  def resources
    router.resources
  end

  def router
    container[:router]
  end

  def env
    Environment.new container.env
  end

  def container
    Container
  end
end
