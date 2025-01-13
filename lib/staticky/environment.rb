# frozen_string_literal: true

module Staticky
  Environment = Data.define(:name) do
    def production? = name == :production
    def development? = name == :development
    def test? = name == :test
  end
end
