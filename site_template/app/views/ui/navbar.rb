# frozen_string_literal: true

module UI
  class Navbar < Component
    def view_template
      header(**attrs) do
        a(href: "/", class: "btn btn-ghost") { Site.title }
      end
    end

    private

    def theme
      {
        container: "p-xs"
      }
    end
  end
end
