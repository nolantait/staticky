# frozen_string_literal: true

RSpec.describe Staticky::Resource do
  describe "#initialize" do
    it "raises an error with an invalid URI" do
      expect { described_class.new(url: nil) }
        .to raise_error(ArgumentError)
    end
  end

  describe "#filepath" do
    it "returns 'index.html' for the root URL" do
      expect(described_class.new(url: "/").filepath.to_s).to eq("index.html")
    end

    it "returns 'about.html' for the '/about' URL" do
      expect(described_class.new(url: "/about").filepath.to_s).to eq("about.html")
    end

    it "returns nested paths for nested URLs" do
      expect(described_class.new(url: "/about/team").filepath.to_s).to eq("about/team.html")
    end
  end

  describe "#build_path" do
    before do
      Staticky.configure do |config|
        config.build_path = Pathname.new("build")
      end
    end

    it "returns the full path to the file" do
      expect(described_class.new(url: "/about/team").build_path).to eq(Pathname.new("build/about/team.html"))
    end
  end
end
