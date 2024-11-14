# frozen_string_literal: true

class ApplicationPage < ApplicationComponent
  def around_template(&) = render Layouts::Page.new(&)
end
