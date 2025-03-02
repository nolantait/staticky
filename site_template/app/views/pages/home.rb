# frozen_string_literal: true

module Pages
  class Home < ApplicationPage
    include Protos::Typography

    def view_template
      render Protos::Hero.new(
        class: "min-h-96",
        style: "background-image: url(#{asset_path("images/hero.jpg")})"
      ) do |hero|
        hero.overlay
        hero.content(class: "flex-col text-white") do
          h1 { "Ruby maximalism" }
          h2(margin: false, size: :sm) { "Zen vibes only" }

          link_to(
            "Learn more",
            Errors::NotFound,
            class: "btn btn-primary mt-md"
          )
        end
      end
    end
  end
end
