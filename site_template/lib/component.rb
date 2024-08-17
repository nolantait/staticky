# frozen_string_literal: true

require "staticky/phlex/view_helpers"

class Component < Protos::Component
  include ViteHelpers

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
