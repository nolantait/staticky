# frozen_string_literal: true

module Layouts
  class Site < Layout
    include Phlex::DeferredRender

    def view_template
      doctype
      html lang: "en", data: { theme: "onedark" } do
        render Layouts::Head.new(&head)

        body do
          render UI::Navbar.new(class: css[:navbar])
          main(class: css[:main], &content)
          render UI::Footer.new(class: css[:footer])
        end
      end
    end

    def with_head(&block)
      @head = block
    end

    def with_content(&block)
      @content = block
    end

    private

    def content
      @content || proc { }
    end

    def head
      @head || proc { }
    end
  end
end
