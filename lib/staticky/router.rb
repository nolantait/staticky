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

    def self.plugin(plugin, ...)
      plugin = Routing::Plugins.load_plugin(plugin) if plugin.is_a?(Symbol)
      unless plugin.is_a?(Module)
        raise ArgumentError, "Invalid plugin type: #{plugin.class.inspect}"
      end

      if plugin.respond_to?(:load_dependencies)
        plugin.load_dependencies(self, ...)
      end

      include plugin::InstanceMethods if defined?(plugin::InstanceMethods)
      extend plugin::ClassMethods if defined?(plugin::ClassMethods)

      plugin.configure(self, ...) if plugin.respond_to?(:configure)
    end

    plugin :prelude
  end
end
