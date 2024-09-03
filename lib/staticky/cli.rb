# frozen_string_literal: true

require "dry/cli"

module Staticky
  module CLI
    def self.new(...)
      Dry::CLI.new(Commands)
    end
  end
end
