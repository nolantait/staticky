# frozen_string_literal: true

module Staticky
  class Application < Dry::System::Container
    # This class coordinates the booting process to add our dependencies.
    # We use zeitwerk to autoload our constants in the lib/staticky folder.
    #
    # Monitoring is enabled to hook into calls to certain dependencies.
    #
    # ```ruby
    # Staticky.application.monitor(:builder, methods: %i[call]) do |event|
    #   Staticky.logger.info "Built site in #{event[:time]}ms"
    # end
    # ```

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

    register(:files, memoize: true) { Staticky::Filesystem.real }
    register(:router, memoize: true) { Staticky::Router.new }
    register(:builder, memoize: true) { Staticky::Builder.new }
    register(:generator) { Staticky::Generator.new }
  end
end
