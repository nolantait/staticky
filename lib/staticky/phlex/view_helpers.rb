# frozen_string_literal: true

module Staticky
  module Phlex
    module ViewHelpers
      def helpers
        @_view_context
      end

      def link_to(text = nil, href, **, &block) # rubocop:disable Style/OptionalArguments
        block ||= proc { text }
        href = Staticky.router.resolve(href)
        href = href.uri.to_s unless href.is_a?(String)

        a(href:, **, &block)
      end
    end
  end
end

Phlex::SGML.prepend Staticky::Phlex::ViewHelpers
