# frozen_string_literal: true

require "capybara"
require "capybara/rspec"

TestComponent = Class.new(Phlex::HTML) do
  def view_template = plain("Hello world")
end

Staticky.router.define do
  root to: TestComponent
end

Capybara.app = Staticky.server

RSpec.describe Staticky::Server, type: :feature do
  it "boots up the app" do
    visit "/"

    expect(page).to have_content("Hello world")
  end
end
