# frozen_string_literal: true

module Staticky
  module Phlex
    module ViewHelpers
      def link_to(text, href, **, &block) # rubocop:disable Metrics/ParameterLists
        block ||= proc { text }
        href = Staticky.router.resolve(href)
        href = href.url unless href.is_a?(String)

        a(href:, **, &block)
      end
    end
  end
end

Phlex::SGML.prepend Staticky::Phlex::ViewHelpers
