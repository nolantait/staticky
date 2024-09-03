# frozen_string_literal: true

module Staticky
  module CLI
    module Commands
      class Build < Dry::CLI::Command
        desc "Build site"

        def call(*) = Staticky.builder.call
      end
    end
  end
end
