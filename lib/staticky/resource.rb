# frozen_string_literal: true

module Staticky
  class Resource
    attr_reader :url, :uri, :component

    # url -> string
    # component -> Phlex::HTML
    def initialize(url:, component:, destination: Staticky.build_path)
      @url = url
      @uri = parse_url(url)
      @component = component
      # Where the resource will be written to when the site is built
      @destination = destination
    rescue URI::InvalidURIError
      raise ArgumentError, "Invalid URL: #{url}"
    end

    def filepath
      @destination.join(basename)
    end

    def read
      filepath.read
    end

    def basename
      root? ? "index.html" : "#{url}.html"
    end

    def root?
      url == "/"
    end

    def build(view_context: ViewContext.new(self))
      component.call(view_context:)
    end

    private

    def parse_url(url)
      URI(url).tap do |uri|
        uri.path = "/#{uri.path}" unless uri.path.start_with?("/")
      end
    end
  end
end
