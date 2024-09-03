# frozen_string_literal: true

module Staticky
  class Router
    # DOCS: Holds routes as a class instance variable. This class is expected to
    # be used as a singleton by requiring the "routes.rb" file.
    #
    # NOTE: Why do we need our own router? Why not just use Roda for these
    # definitions? Roda is a routing tree and cannot be introspected easily.
    # In Staticky when we build we need to do a lot of introspection to link
    # routes to resources on the file system.

    Error = Class.new(Staticky::Error)

    def initialize
      @definition = Staticky::Router::Definition.new
    end

    def filepaths = @definition.filepaths
    def resources = @definition.resources

    def define(&block)
      tap do
        @definition.instance_eval(&block)
      end
    end

    def resolve(path)
      uri = URI(path)
      # Return absolute paths as is
      return path if uri.absolute?

      @definition.resolve(path)
    rescue URI::InvalidURIError
      raise Error, "Path #{path} is not a valid URI"
    end
  end
end
