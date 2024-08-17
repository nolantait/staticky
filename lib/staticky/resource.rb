# frozen_string_literal: true

module Staticky
  Resource = Data.define(:url, :component) do
    def full_filepath
      Staticky.build_path.join(filepath)
    end

    def read
      full_filepath.read
    end

    def filepath
      root? ? "index.html" : "#{url}.html"
    end

    def root?
      url == "/"
    end

    def build(view_context: ViewContext.new(self))
      component.call(view_context:)
    end
  end
end
