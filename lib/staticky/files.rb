# frozen_string_literal: true

require "delegate"
require "dry-files"

module Staticky
  class Files < SimpleDelegator
    def self.test
      files = Dry::Files.new(memory: true)
      new(files)
    end

    def self.real
      files = Dry::Files.new
      new(files)
    end

    def touch(*files)
      files.each do |file|
        super(file)
      end
    end

    def children(directory)
      tokens = [".", ".."]
      entries(directory).reject { |entry| tokens.include?(entry) }
    end
  end
end
