# frozen_string_literal: true

module Layouts
  class Error < Layout
    def view_template(&block)
      render Layouts::Site.new do
        div(class: "grid place-items-center h-[--main-scene]") do
          section(class: "flex flex-col place-items-center gap-sm", &block)
        end
      end
    end
  end
end
