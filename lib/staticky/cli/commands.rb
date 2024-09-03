# frozen_string_literal: true

module Staticky
  module CLI
    module Commands
      extend Dry::CLI::Registry

      register "version", Version
      register "build", Build
      register "new", Generate
    end
  end
end
