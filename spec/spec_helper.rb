# frozen_string_literal: true

require "debug"
require "staticky"
require "dry/system/stubs"

Staticky.config.logger = Logger.new($stdout)
Staticky.config.root_path = Pathname.new(__dir__).join("fixtures")
Staticky.config.build_path = Pathname.new(__dir__).join("fixtures/build")
Staticky.config.env = :test

Staticky.container.enable_stubs!

Staticky.container.stub(:files, Staticky::Filesystem.test)

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
