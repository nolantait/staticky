# frozen_string_literal: true

module Staticky
  module Routing
    module Plugins
      module Prelude
        module ClassMethods
          def new(**env)
            super().tap do |router|
              env.each do |key, value|
                router.send(:"#{key}=", value)
              end
            end
          end
        end

        module InstanceMethods
          def define(&block)
            tap do
              instance_eval(&block)
            end
          end

          def match(path, to:, as: Resource)
            # Strip leading slash
            path = path.to_s.gsub(%r{^/}, "") unless path == "/"

            resource = case to
            when ->(x) { x.is_a?(Class) || x.is_a?(::Phlex::HTML) }
              component = ensure_instance(to)
              as.new(component:, url: path)
            else
              raise Router::Error, "Invalid route target: #{to.inspect}"
            end

            resources << resource
            index_resource(path, resource)
          end

          def root(to:)
            match("/", to:)
          end

          def resolve(path)
            return path if path.is_a?(String) && path.start_with?("#")
            return lookup(path) if path.is_a?(Class)

            # Strip leading slash
            path = path.to_s.gsub(%r{^/}, "")

            uri = URI(path)
            # Return absolute paths as is
            return path if uri.absolute?

            if uri.path.size > 1 && uri.path.start_with?("/")
              uri.path = uri.path[1..]
            end

            lookup(uri.path)
          rescue URI::InvalidURIError
            raise Router::Error, "Invalid path: #{path}"
          rescue KeyError
            raise Router::Error, "No route matches #{path}"
          end

          def resources = @resources ||= []
          def filepaths = resources.map(&:filepath)

          private

          def lookup(path)
            @routes_by_path.fetch(path) do
              @routes_by_component.fetch(path)
            end
          end

          def index_resource(path, resource)
            routes_by_path[path] = resource
            routes_by_component[resource.component.class] = resource
          end

          def routes_by_path = @routes_by_path ||= {}
          def routes_by_component = @routes_by_component ||= {}

          def ensure_instance(component)
            component.is_a?(Class) ? component.new : component
          end
        end
      end

      register_plugin(:prelude, Prelude)
    end
  end
end
