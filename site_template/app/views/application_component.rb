# frozen_string_literal: true

require "staticky/phlex/view_helpers"

class ApplicationComponent < Protos::Component
  include ViteHelpers

  class NullViewContext
    def root? = true
    def current_path = "/"
  end

  def helpers
    context[:helpers] ||= NullViewContext.new
  end

  def asset_path(...)
    vite_asset_path(...)
  end

  def image_tag(path, alt:, **)
    img(src: asset_path(path), alt:, **)
  end

  def icon(...)
    render Icon.new(...)
  end

  def inline_link(text, url)
    render Protos::Typography::InlineLink.new(href: url) { text }
  end
end
