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

          def match(path, to:, type: Resource)
            case to
            when ->(x) { x.is_a?(Class) || x.is_a?(Phlex::HTML) }
              component = ensure_instance(to)
              resources << resource = type.new(component:, url: path)
              index_resource(path, resource)
            else
              raise Router::Error, "Invalid route target: #{to.inspect}"
            end
          end

          def root(to:)
            match("/", to:)
          end

          def resolve(path)
            return path if path.is_a?(String) && path.start_with?("#")
            return lookup(path) if path.is_a?(Class)

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
    end
  end
end
