# frozen_string_literal: true

require "roda"

require_relative "../staticky"

module Staticky
  class Server < Roda
    # This runs a local development server that serves the static files
    # Require this in your config.ru file and run something like `rackup` to
    # start the server

    NotFound = Class.new(Staticky::Error)

    plugin :common_logger, Staticky.server_logger, method: :debug
    plugin :render, engine: "html"
    plugin :public

    plugin :not_found do
      raise NotFound if Staticky.env.test?

      Staticky.build_path.join("404.html").read
    end

    plugin :error_handler do |e|
      raise e if Staticky.env.test?

      Staticky.build_path.join("500.html").read
    end

    route do |r|
      Staticky.resources.each do |resource|
        case resource.filepath
        when "index.html"
          r.root do
            render(inline: resource.read)
          end
        else
          r.get resource.url do
            render(inline: resource.read)
          end
        end
      end

      r.public
    end
  end
end
