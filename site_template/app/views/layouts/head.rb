# frozen_string_literal: true

module Layouts
  class Head < ApplicationComponent
    option :title, default: -> { ::Site.title }, reader: false
    option :description, default: -> { ::Site.description }, reader: false

    def view_template
      head do
        title { @title }
        meta name: "description", content: @description
        meta charset: "utf-8"
        meta name: "viewport",
             content: "width=device-width,initial-scale=1,viewport-fit=cover"
        meta name: "turbo-cache-control", content: "no-preview"
        meta name: "turbo-refresh-method", content: "morph"
        meta name: "turbo-refresh-scroll", content: "preserve"
        meta name: "theme-color", content: "#61afef"
        meta name: "mobile-web-app-capable", content: "yes"
        meta name: "apple-touch-fullscreen", content: "yes"
        meta name: "apple-mobile-web-app-capable", content: "yes"
        meta name: "apple-mobile-web-app-status-bar-style", content: "default"
        meta name: "apple-mobile-web-app-title", content: @title

        link rel: "canonical", href: ::Site.url_for(helpers.current_path)
        link rel: "apple-touch-icon", href: "/apple-touch-icon.png"
        link rel: "icon",
             type: "image/png",
             sizes: "32x32",
             href: "/favicon-32x32.png"
        link rel: "icon",
             type: "image/png",
             sizes: "16x16",
             href: "/favicon-16x16.png"
        link rel: "manifest", href: "/site.webmanifest"

        meta property: "og:title", content: @title
        meta property: "og:type", content: "website"
        meta property: "og:locale", content: "en_US"
        meta property: "og:url", content: ::Site.url
        meta property: "og:site_name", content: ::Site.title
        meta property: "twitter:title", content: ::Site.title
        meta name: "twitter:card", content: "summary"
        meta name: "twitter:site", content: ::Site.twitter
        meta name: "twitter:creator", content: ::Site.twitter

        vite_client_tag unless ENV["RACK_ENV"] == "production"
        javascript_tag "application"

        yield if block_given?
      end
    end

    private

    def javascript_tag(...)
      vite_javascript_tag(...)
    end
  end
end
