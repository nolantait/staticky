# frozen_string_literal: true

module Layouts
  class Post < Layout
    def around_template(&block)
      render Layouts::Site.new(&block)
    end

    def view_template(&block)
      div(**attrs, &block)
    end
  end
end
