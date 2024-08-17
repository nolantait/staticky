# frozen_string_literal: true

require "dry/cli"

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

      class New < Dry::CLI::Command
        desc "Create new site"

        def call(*) = Staticky.generator.call
      end

      register "version", Version
      register "build", Build
      register "new", New
    end

    def self.new(...)
      Dry::CLI.new(Commands)
    end
  end
end
