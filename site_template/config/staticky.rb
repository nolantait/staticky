# frozen_string_literal: true

Staticky.configure do |config|
  config.build_path = Pathname.new("build")
  config.root_path = Pathname.new(__dir__).join("..")
  config.live_reloading = true
end
