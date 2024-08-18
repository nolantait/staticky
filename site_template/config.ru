# frozen_string_literal: true

require "logger"
require "./config/boot"
require "staticky/server"

use(ViteRuby::DevServerProxy, ssl_verify_none: true) if ViteRuby.run_proxy?
run Staticky::Server.app.freeze
