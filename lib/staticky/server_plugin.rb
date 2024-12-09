module Staticky
  module ServerPlugin
    def self.load_dependencies(app)
      app.plugin :common_logger, Staticky.server_logger, method: :debug
      app.plugin :render, engine: "html"
      app.plugin :public
      app.plugin :exception_page

      app.plugin :not_found do
        raise Staticky::Server::NotFound if Staticky.env.test?

        Staticky.build_path.join("404.html").read
      end

      app.plugin :error_handler do |error|
        raise error if Staticky.env.test?
        next exception_page(error) if Staticky.env.development?

        Staticky.build_path.join("500.html").read
      end
    end

    module RequestMethods
      def staticky
        unless Staticky.env.development? && Staticky.config.live_reloading
          return
        end

        ServerPlugins::LiveReloading.setup_live_reload(scope)
      end
    end

    Roda::RodaPlugins.register_plugin(:staticky_server, self)
  end
end
