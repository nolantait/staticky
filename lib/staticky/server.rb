# frozen_string_literal: true

require "roda"
require "logger"
require "tilt"

module Staticky
  class Server < Roda
    NotFound = Class.new(Staticky::Error)

    plugin :common_logger, Logger.new($stdout), method: :debug
    plugin :render, engine: "html"

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

      # Need to return nil or Roda is unhappy
      nil
    end
  end
end
