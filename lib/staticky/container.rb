# frozen_string_literal: true

module Staticky
  class Container < Dry::System::Container
    use :env
    use :zeitwerk
    use :logging

    setting :build_path, default: Pathname.new("build")
    setting :root_path, default: Pathname(__dir__)

    register :router, Router.new
    register :files, Files.real
  end
end
