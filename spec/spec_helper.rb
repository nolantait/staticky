# frozen_string_literal: true

require "debug"
require "staticky"
require "dry/system/stubs"

Staticky.application.enable_stubs!

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before do
    Staticky.application.stub(:files, Staticky::Filesystem.test)

    Staticky.configure do |config|
      config.env = :test
      config.build_path = Pathname.new("build")
      config.root_path = Pathname(__dir__).join("..")
    end
  end
end

Pathname.glob(Pathname(__dir__).join("support/**/*.rb")).each { |file| require file }
