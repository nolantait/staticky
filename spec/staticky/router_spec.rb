# frozen_string_literal: true

RSpec.describe Staticky::Router do
  it "defines routes" do
    stub_const("TestComponent", Class.new(Phlex::HTML))

    router = subject.define do
      root to: TestComponent
      match "hello", to: TestComponent
    end

    expect(router.resolve("/").component).to be_a(TestComponent)
    expect(router.resolve("hello").component).to be_a(TestComponent)
    expect(router.filepaths).to include("index.html", "hello.html")
  end
end
