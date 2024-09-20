# frozen_string_literal: true

module Staticky
  module Routing
    module Plugins
      def self.load_plugin(key)
        inflector = Dry::Inflector.new
        class_name = inflector.camelize(key)
        inflector.constantize("Staticky::Routing::Plugins::#{class_name}")
      end
    end
  end
end
