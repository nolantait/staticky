module Staticky
  module Resources
    module Plugins
      def self.load_plugin(key)
        inflector = Dry::Inflector.new
        class_name = inflector.camelize(key)
        inflector.constantize("Staticky::Resources::Plugins::#{class_name}")
      end
    end
  end
end
