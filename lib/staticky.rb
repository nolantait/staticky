# frozen_string_literal: true

require "phlex"

require_relative "staticky/error"
require_relative "staticky/version"
require_relative "staticky/environment"
require_relative "staticky/resource"
require_relative "staticky/files"
require_relative "staticky/router"
require_relative "staticky/builder"
require_relative "staticky/server"
require_relative "staticky/container"

module Staticky
  module_function

  # DOCS: Module for static site infrastructure such as:
  # - Defining routes
  # - Compiling templates
  # - Development server
  # - Managing filesystem

  def configure(&block)
    block.call(container.config)
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

  def server
    container[:server]
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

  module ViewHelpers
    def link_to(text, href, **, &block) # rubocop:disable Metrics/ParameterLists
      block ||= proc { text }
      href = Staticky.router.resolve(href).url

      a(href:, **, &block)
    end
  end

  Phlex::SGML.prepend Staticky::ViewHelpers
end
