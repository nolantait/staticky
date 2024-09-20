# frozen_string_literal: true

module Staticky
  module Pluggable
    class Resolver < Dry::Container::Resolver
      def initialize(klass)
        @klass = klass
      end

      def call(container, key)
        container.fetch(key.to_s).call
      end
    end

    module ClassMethods
      def load_plugin(key)
        resolve(key)
      end

      def register_plugin(key, klass)
        register(key.to_s, klass)
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
