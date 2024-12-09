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

    def view_template(&block)
      render UI::Navbar.new(class: css[:navbar])
      main(**attrs, &block)
      render UI::Footer.new(class: css[:footer])
    end

    private

    def head(&block)
      render Head.new(&block)
    end
  end
end
