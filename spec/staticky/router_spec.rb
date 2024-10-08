# frozen_string_literal: true

RSpec.describe Staticky::Router do
  before do
    stub_const("TestComponent", Class.new(Phlex::HTML))
  end

  let(:router) do
    subject.define do
      root to: TestComponent
      match "hello", to: TestComponent
    end
  end

  it "defines routes" do
    expect(router.resolve("/").component).to be_a(TestComponent)
    expect(router.resolve("hello").component).to be_a(TestComponent)
    expect(router.resolve("/hello").component).to be_a(TestComponent)
  end

  it "returns the expected filepaths" do
    filepaths = router.filepaths.map { |path| path.basename.to_s }
    expect(filepaths).to include("index.html", "hello.html")
  end

  it "resolves a component class" do
    expect(router.resolve(TestComponent).component).to be_a(TestComponent)
  end

  it "resolves anchor urls" do
    expect(router.resolve("#anchor")).to eq("#anchor")
  end

  it "resolves absolute urls" do
    expect(router.resolve("https://example.com")).to eq("https://example.com")
  end

  it "resolves mailto urls" do
    expect(router.resolve("mailto:email@example.com")).to eq("mailto:email@example.com")
  end

  it "handles invalid urls" do
    expect { router.resolve("\\invalid") }
      .to raise_error(Staticky::Router::Error)
  end

  it "handles unresolved urls" do
    expect { router.resolve("/unresolved") }
      .to raise_error(Staticky::Router::Error)
  end
end
