# frozen_string_literal: true

require "dry/cli"
require "debug"

module Staticky
  module CLI
    module Commands
      extend Dry::CLI::Registry

      class Version < Dry::CLI::Command
        desc "Print version"

        def call(*) = puts VERSION
      end

      class Build < Dry::CLI::Command
        desc "Build site"

        def call(*) = Staticky.builder.call
      end

      class Generate < Dry::CLI::Command
        desc "Create new site"

        argument :path,
                 required: true,
                 desc: "Relative path where the site will be generated"

        option :url,
               default: "https://example.com",
               desc: "Site URL",
               aliases: ["-u"]
        option :title,
               default: "Example",
               desc: "Site title",
               aliases: ["-t"]
        option :description,
               default: "Example site",
               desc: "Site description",
               aliases: ["-d"]
        option :twitter,
               default: "",
               desc: "Twitter handle",
               aliases: ["-t"]

        def call(path:, **options)
          path = Pathname.new(path).expand_path

          Staticky.generator.call(path, **options)

          commands = [
            "bundle install",
            "bundle binstubs bundler rake rspec-core vite_ruby",
            "yarn install",
            "bin/rspec"
          ].join(" && ")

          system(commands, chdir: path) || abort("install failed")
        end
      end

      register "version", Version
      register "build", Build
      register "new", Generate
    end

    def self.new(...)
      Dry::CLI.new(Commands)
    end
  end
end
