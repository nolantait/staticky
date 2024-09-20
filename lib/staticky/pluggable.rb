module Staticky
  module Pluggable
    class Resolver < Dry::Container::Resolver
      def initialize(klass)
        @klass = klass
      end

      def call(container, key)
        container.fetch(key, @klass.load_staticky_plugin(key))
      end
    end

    module ClassMethods
      def load_plugin(key)
        resolve(key)
      end

      def load_staticky_plugin(key)
        inflector = Dry::Inflector.new
        class_name = inflector.camelize(key)
        inflector.constantize("#{namespace}::Plugins::#{class_name}")
      end

      def register_plugin(key, klass)
        register(key, klass)
      end
    end

    def self.included(base)
      base.extend Dry::Container::Mixin
      base.extend ClassMethods
      base.config.resolver = Resolver.new(base)

      base.define_singleton_method :namespace do
        base.name.split("::")[0..-2].join("::")
      end
    end
  end
end
