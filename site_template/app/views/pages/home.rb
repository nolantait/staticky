# frozen_string_literal: true

module Pages
  class Home < Page
    include Protos::Typography

    def view_template
      render Protos::Hero.new(
        class: "h-96",
        style: "background-image: url(#{asset_path("images/hero.jpg")})"
      ) do |hero|
        hero.overlay(class: "opacity-90")
        hero.content(class: "flex-col text-white") do
          h1 { "Ruby maximalism" }
          p(margin: false) { "Zen vibes only" }

          link_to("Learn more", Errors::NotFound)
        end
      end
    end
  end
end
