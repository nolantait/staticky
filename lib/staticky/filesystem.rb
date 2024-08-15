# frozen_string_literal: true

require "delegate"
require "staticky-files"

module Staticky
  class Filesystem < SimpleDelegator
    def self.test
      files = Staticky::Files.new(memory: true)
      new(files)
    end

    def self.real
      files = Staticky::Files.new
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
