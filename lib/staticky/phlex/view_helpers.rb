# frozen_string_literal: true

module Staticky
  module Phlex
    module ViewHelpers
      def link_to(text, href, **kwargs, &block) # rubocop:disable Metrics/ParameterLists
        block ||= proc { text }
        href = Staticky.router.resolve(href).url

        a(href:, **kwargs, &block)
      end
    end
  end
end

Phlex::SGML.prepend Staticky::Phlex::ViewHelpers
