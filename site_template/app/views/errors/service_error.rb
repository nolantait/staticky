# frozen_string_literal: true

module Errors
  class ServiceError < ApplicationPage
    include Protos::Typography

    def around_template(&) = render Layouts::Error.new(&)

    def view_template
      span(class: "font-thin text-8xl") { "500" }
      h1 { "Something went wrong." }
      link_to("Back to home", Pages::Home, class: "btn mt-sm")
    end
  end
end
