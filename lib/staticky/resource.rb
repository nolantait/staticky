# frozen_string_literal: true

module Staticky
  class Resource
    def self.plugin(plugin, *, &block)
      plugin = Resources::Plugins.load_plugin(plugin) if plugin.is_a?(Symbol)
      unless plugin.is_a?(Module)
        raise ArgumentError, "Invalid plugin type: #{plugin.class.inspect}"
      end

      if plugin.respond_to?(:load_dependencies)
        plugin.load_dependencies(self, *, &block)
      end

      include plugin::InstanceMethods if defined?(plugin::InstanceMethods)
      extend plugin::ClassMethods if defined?(plugin::ClassMethods)

      plugin.configure(self, *, &block) if plugin.respond_to?(:configure)
    end

    plugin :prelude
    plugin :phlex
  end
end
