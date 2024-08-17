# frozen_string_literal: true

module Staticky
  class Container < Dry::System::Container
    use :env
    use :zeitwerk
    use :logging

    configure do |config|
      config.root = Pathname(__dir__).join("..").join("..")
      config.component_dirs.add "lib" do |dir|
        dir.add_to_load_path = false
        dir.auto_register = false
        dir.namespaces.add "staticky", key: nil
      end
    end

    register(:files, Staticky::Filesystem.real)
    register(:router, Staticky::Router.new)
    register(:builder, Staticky::Builder.new)
  end
end
