# frozen_string_literal: true

module Layouts
  class Site < ApplicationLayout
    def around_template(&)
      doctype
      html lang: "en", data: { theme: "onedark" } do
        head
        body(&)
      end
    end

    def view_template(&)
      render UI::Navbar.new(class: css[:navbar])
      main(**attrs, &)
      render UI::Footer.new(class: css[:footer])
    end

    private

    def head(&)
      render Head.new(&)
    end

    def theme
      {
        container: "min-h-screen"
      }
    end
  end
end
