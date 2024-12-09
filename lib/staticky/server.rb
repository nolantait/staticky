# frozen_string_literal: true

require "roda"

require_relative "../staticky"
require_relative "server_plugin"

module Staticky
  class Server < Roda
    # This runs a local development server that serves the static files
    # Require this in your config.ru file and run something like `rackup` to
    # start the server

    NotFound = Class.new(Staticky::Error)

    plugin :staticky_server

    route do |r|
      r.staticky

      Staticky.resources.each do |resource|
        case resource.filepath.to_s
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
