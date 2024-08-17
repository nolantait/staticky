module Staticky
  class ViewContext
    def initialize(resource)
      @resource = resource
    end

    def root?
      @resource.root?
    end
  end
end
