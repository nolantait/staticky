# frozen_string_literal: true

require "dry/system"

module Staticky
  class Container < Dry::System::Container
    use :env
    use :zeitwerk

    setting :build_path, default: Pathname.new("build")
    setting :root_path, default: Pathname(__dir__)

    register :server, Staticky::Server.freeze.app
    register :router, Staticky::Router.new
    register :files, Staticky::Files.real
  end
end
