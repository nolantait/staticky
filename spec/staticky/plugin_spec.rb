RSpec.describe Staticky::Resource::Plugins do
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
    stub_const(
      "MyResource", Class.new(Staticky::Resource) do
        plugin HelloWorld
      end
    )
  end

  it "adds the plugin to the resource" do
    expect(MyResource.new.hello_world).to eq("Hello world")
  end
end
