# frozen_string_literal: true

require "debug"
require "staticky"
require "dry/system/stubs"

Staticky.configure do |config|
  config.root_path = Pathname.new(__dir__).join("fixtures")
  config.build_path = Pathname.new(__dir__).join("fixtures/build")
  config.env = :test
end

Staticky::Container.enable_stubs!

Staticky::Container.stub(:files, Staticky::Files.test)

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
