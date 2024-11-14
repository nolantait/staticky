# frozen_string_literal: true

module Errors
  class ServiceError < ApplicationPage
    include Protos::Typography

    def self.layout = Layouts::Error

    def view_template
      h1 { "Something went wrong." }
      link_to("Back to home", Pages::Home, class: "link")
    end
  end
end
