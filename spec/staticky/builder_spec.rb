# frozen_string_literal: true

RSpec.describe Staticky::Builder do
  before do
    stub_const(
      "TestComponent", Class.new(Phlex::HTML) do
        def view_template = plain("Hello world")
      end
    )

    Staticky.router.define do
      root to: TestComponent
      match "/about", to: TestComponent
    end
  end

  it "compiles the homepage" do
    files = Staticky::Container[:files]
    files.touch(Staticky.root_path.join("public/favicon.ico"))

    builder = described_class.new(files:)
    builder.call

    favicon = Staticky.build_path.join("favicon.ico")
    index = Staticky.build_path.join("index.html")
    about = Staticky.build_path.join("about.html")

    expect(files.exist?(favicon)).to be(true)
    expect(files.exist?(index)).to be(true)
    expect(files.exist?(about)).to be(true)
  end
end
