# frozen_string_literal: true

RSpec.describe Staticky::Resources::Plugins do
  before do
    stub_const("HelloWorld", Module.new)
    stub_const(
      "HelloWorld::InstanceMethods",
      Module.new do
        def hello_world
          "Hello world"
        end
      end
    )

    described_class.register_plugin(:hello_world, HelloWorld)

    stub_const(
      "MyResource", Class.new(Staticky::Resource) do
        plugin :hello_world
      end
    )
  end

  it "adds the plugin to the resource" do
    expect(MyResource.new.hello_world).to eq("Hello world")
  end
end
