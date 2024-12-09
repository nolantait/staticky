# frozen_string_literal: true

require "capybara"
require "capybara/rspec"

require "staticky/server"

RSpec.describe Staticky::Server, type: :feature do
  before do
    stub_const(
      "TestComponent", Class.new(Phlex::HTML) do
        def view_template = plain("Hello world")
      end
    )

    Staticky.router.define do
      root to: TestComponent
    end

    Staticky.files.write(
      Staticky.build_path.join("index.html"),
      "Hello world"
    )

    Capybara.app = described_class.app.freeze
  end

  it "boots up the app" do
    visit "/"

    expect(page).to have_content("Hello world")
  end
end
