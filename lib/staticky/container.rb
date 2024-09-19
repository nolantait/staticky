# frozen_string_literal: true

module Staticky
  class Container < Dry::System::Container
    use :zeitwerk
    use :monitoring

    configure do |config|
      config.root = Pathname(__dir__).join("..").join("..")
      config.inflector = Dry::Inflector.new do |inflections|
        inflections.acronym("CLI")
      end
      config.component_dirs.add "lib" do |dir|
        dir.add_to_load_path = false
        dir.auto_register = false
        dir.namespaces.add "staticky", key: nil
      end
    end

    register(:files, Staticky::Filesystem.real)
    register(:router, Staticky::Router.new)
    register(:builder, Staticky::Builder.new)
    register(:generator, Staticky::Generator.new)
  end
end
