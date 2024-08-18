# frozen_string_literal: true

module UI
  class Footer < Component
    def view_template
      footer(**attrs) do
        p(class: "opacity-80 text-sm") do
          "All rights reserved. © #{Time.now.year}"
        end
      end
    end

    private

    def theme
      {
        container: "flex justify-center w-full py-lg text-center"
      }
    end
  end
end
