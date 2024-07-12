# frozen_string_literal: true

RSpec.describe Staticky::Builder do
  it "compiles the homepage" do
    files = Staticky::Container[:files]
    files.touch(Staticky.root_path.join("public/favicon.ico"))

    builder = described_class.new(files:)
    builder.call

    favicon = Staticky.build_path.join("favicon.ico")
    index = Staticky.build_path.join("index.html")

    expect(files.exist?(favicon)).to be(true)
    expect(files.exist?(index)).to be(true)
  end
end
