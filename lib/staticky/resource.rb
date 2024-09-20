# frozen_string_literal: true

module Staticky
  class Resource
    attr_reader :url, :uri, :component

    module InstanceMethods
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

    def self.plugin(plugin, *, &block)
      plugin = Plugins.load_plugin(plugin) if plugin.is_a?(Symbol)

      if plugin.respond_to?(:load_dependencies)
        plugin.load_dependencies(self, *, &block)
      end

      include plugin::InstanceMethods if defined?(plugin::InstanceMethods)
      extend plugin::ClassMethods if defined?(plugin::ClassMethods)

      plugin.configure(self, *, &block) if plugin.respond_to?(:configure)
    end

    plugin self

    def initialize(url, renderable, destination: Staticky.build_path, **options)
      @url = url
      @renderable = renderable
      @destination = destination
      @options = options
    end
  end
end
