RSpec.describe Staticky::Generator do
  it "generates the site" do
    files = Staticky::Filesystem.test

    generator = described_class.new(files:)

    generator.call(
      "/tmp/site",
      title: "My Site",
      description: "My Site Description",
      url: "https://example.com"
    )

    expect(files.exist?("/tmp/site/config/site.rb")).to be(true)
    expect(files.exist?("/tmp/site/Dockerfile")).to be(true)
  end
end
