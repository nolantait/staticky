# frozen_string_literal: true

module Staticky
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
end
