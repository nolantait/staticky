# frozen_string_literal: true

module Layouts
  class Error < Site
    def view_template(&)
      div(class: "grid place-items-center h-[--main-scene]") do
        section(class: "flex flex-col place-items-center gap-sm", &)
      end
    end
  end
end
