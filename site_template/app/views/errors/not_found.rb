# frozen_string_literal: true

module Errors
  class NotFound < ApplicationPage
    include Protos::Typography

    def around_template(&) = render Layouts::Error.new(&)

    def view_template
      span(class: "font-thin text-8xl") { "404" }
      h1 { "Page not found." }
      link_to("Back to home", Pages::Home, class: "btn mt-sm")
    end
  end
end
