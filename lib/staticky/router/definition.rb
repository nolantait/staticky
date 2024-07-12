module Staticky
  class Router
    class Definition
      attr_reader :resources

      def initialize
        @routes_by_path = {}
        @routes_by_component = {}
        @resources = []
      end

      def match(path, to:)
        component = to.then do |object|
          object.is_a?(Class) ? object.new : object
        end

        @resources << resource = Resource.new(url: path, component:)
        @routes_by_path[path] = resource
        @routes_by_component[component.class] = resource
      end

      def root(to:)
        match("/", to:)
      end

      def resolve(path)
        @routes_by_path.fetch(path) { @routes_by_component.fetch(path) }
      end

      def delete(path)
        @routes.delete(path)
      end

      def filepaths
        @resources.map { |resource| rename_key(resource.url) }
      end

      private

      def rename_key(key)
        return "index.html" if key == "/"

        "#{key}.html"
      end
    end
  end
end
