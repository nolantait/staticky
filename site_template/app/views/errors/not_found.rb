# frozen_string_literal: true

module Errors
  class NotFound < Page
    include Protos::Typography

    def self.layout = Layouts::Error

    def view_template
      h1 { "Page not found." }
      link_to("Back to home", Pages::Home, class: "link")
    end
  end
end
