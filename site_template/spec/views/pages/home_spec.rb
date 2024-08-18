# frozen_string_literal: true

RSpec.describe Pages::Home do
  it "renders" do
    render described_class.new

    expect(page).to have_css("html")
  end
end
