# frozen_string_literal: true

class Page < Component
  # Example of a nested layout

  def around_template(&block)
    render Layouts::Site.new do |layout|
      layout.with_content(&block)
    end
  end
end
