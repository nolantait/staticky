module Staticky
  module Resources
    module Plugins
      module Phlex
        class ViewContext
          def initialize(resource)
            @resource = resource
          end

          def root?
            @resource.root?
          end

          def current_path
            @resource.url
          end
        end

        module InstanceMethods
          def component=(component)
            @component = component
          end

          def component
            @component
          end

          def build(view_context: ViewContext.new(self))
            component.call(view_context:)
          end
        end
      end
    end
  end
end
