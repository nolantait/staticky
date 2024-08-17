# frozen_string_literal: true

require "dry/cli"

module Staticky
  module CLI
    module Commands
      extend Dry::CLI::Registry

      class Version < Dry::CLI::Command
        desc "Print version"

        def call(*)
          puts VERSION
        end
      end

      class Build < Dry::CLI::Command
        desc "Build site"

        def call(*)
          Staticky.builder.call
        end
      end

      register "version", Version
      register "build", Build
    end

    def self.new(...)
      Dry::CLI.new(Commands)
    end
  end
end
