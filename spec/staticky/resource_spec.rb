# frozen_string_literal: true

RSpec.describe Staticky::Resource do
  describe "#initialize" do
    it "raises an error with an invalid URI" do
      expect { described_class.new(url: nil) }
        .to raise_error(ArgumentError)
    end
  end
end
