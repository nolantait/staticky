# frozen_string_literal: true

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
        # Initialize the component if it's a class
        component = ensure_instance(to)
        @resources << resource = Resource.new(url: path, component:)
        index_resource(path, resource)
      end

      def root(to:)
        match("/", to:)
      end

      def resolve(path)
        @routes_by_path.fetch(path) { @routes_by_component.fetch(path) }
      rescue KeyError
        raise Staticky::Router::Error, "No route matches #{path}"
      end

      def filepaths
        @resources.map(&:filepath)
      end

      private

      def index_resource(path, resource)
        @routes_by_path[path] = resource
        @routes_by_component[resource.component.class] = resource
      end

      def ensure_instance(component)
        component.is_a?(Class) ? component.new : component
      end
    end
  end
end
