# frozen_string_literal: true

RSpec.describe Staticky::Phlex::ViewHelpers, type: :view do
  before do
    stub_const(
      "Component", Class.new(Phlex::HTML) do
        include Staticky::Phlex::ViewHelpers

        def view_template
          link_to("foo", "/foo")
        end
      end
    )
  end

  it "renders the link" do
    Staticky.router.define do
      match "foo", to: Component
      match "bar", to: Component
    end

    render Component.new

    expect(page).to have_link("foo", href: "/foo")
  end
end
