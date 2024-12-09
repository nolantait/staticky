# frozen_string_literal: true

module Staticky
  module Resources
    module Plugins
      module Prelude
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
          def build_path
            destination.join(filepath)
          end

          def filepath
            return Pathname.new("index.html") if root?

            Pathname.new("#{uri.path.gsub(%r{^/}, "")}.html")
          end

          def read
            Staticky.files.read(build_path)
          end

          def root?
            url == "/"
          end

          def uri
            return @uri if defined?(@uri)

            raise ArgumentError, "url is required"
          end

          def destination
            @destination ||= Staticky.build_path
          end

          def destination=(destination)
            @destination = Pathname(destination)
          end

          def url
            return @url if defined?(@url)

            raise ArgumentError, "url is required"
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
      end

      register_plugin(:prelude, Prelude)
    end
  end
end
