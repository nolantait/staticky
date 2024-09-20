# frozen_string_literal: true

module Staticky
  class Resource
    module ClassMethods
      def new(**env)
        super().tap do |resource|
          env.each do |key, value|
            resource.send(:"#{key}=", value)
          end
        end
      end
    end

    module InstanceMethods
      def filepath
        destination.join(basename)
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

      def uri
        raise ArgumentError, "url is required" unless defined?(@uri)

        @uri
      end

      def destination
        @destination ||= Staticky.build_path
      end

      def destination=(destination)
        @destination = Pathname(destination)
      end

      def url
        raise ArgumentError, "url is required" unless defined?(@url)

        @url
      end

      def url=(url)
        @url = url
        @uri = parse_url(url)
      end

      private

      def parse_url(url)
        URI(url).tap do |uri|
          uri.path = "/#{uri.path}" unless uri.path.start_with?("/")
        end
      rescue URI::InvalidURIError => e
        raise ArgumentError, e.message
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
  end
end
