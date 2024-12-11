# frozen_string_literal: true

class ApplicationPage < ApplicationComponent
  def around_template(&block) = render Layouts::Site.new(&block)
end
