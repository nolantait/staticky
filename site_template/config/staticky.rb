# frozen_string_literal: true

Staticky.configure do |config|
  config.build_path = Pathname.new("build")
  config.root_path = Pathname(__dir__).join("..")
end
