# frozen_string_literal: true

module Staticky
  module Utils
    module_function

    def live_reload_js(base_path, debug: false) # rubocop:disable Metrics/MethodLength
      return "" unless Staticky.env.development?

      path = File.join(base_path, "/_staticky/live_reload")

      <<~JAVASCRIPT
        let lastmod = 0;
        let reconnectAttempts = 0;
        let connection = null;
        let lastReloadAt = 0;
        const MIN_RELOAD_INTERVAL = 1000;
        const debug = #{debug};

        function log(...args) {
          if (debug) console.log("[LiveReload]", ...args);
        }

        function statickyReload() {
          if (window.Turbo) {
            log("Reloading with Turbo");
            Turbo.visit(window.location, { action: "replace" });
          } else {
            log("Reloading without Turbo");
            location.reload();
          }
        }

        function safeReload() {
          const now = Date.now();
          if (now - lastReloadAt > MIN_RELOAD_INTERVAL) {
            lastReloadAt = now;
            statickyReload();
          }
        }

        function startLiveReload() {
          if (connection) connection.close();

          connection = new EventSource("#{path}");

          connection.addEventListener("message", (event) => {
            log("Message:", event.data);
            reconnectAttempts = 0;

            if (event.data === "reloaded!") {
              safeReload();
            } else {
              const newmod = Number(event.data);
              if (lastmod < newmod) {
                safeReload();
                lastmod = newmod;
              }
            }
          });

          connection.addEventListener("builderror", (event) => {
            try {
              const errorData = JSON.parse(event.data);
              console.error("[Staticky] Build error:", errorData);
            } catch (e) {
              console.error("[Staticky] Malformed builderror event:", event.data);
            }
          });

          connection.addEventListener("error", () => {
            if (connection.readyState === 2) {
              connection.close();
              reconnectAttempts++;
              if (reconnectAttempts < 25) {
                console.warn("Live reload: reconnecting in 3s...");
                setTimeout(startLiveReload, 3000);
              } else {
                console.error(
                  "Too many live reload failures. Refresh the page to resume."
                );
              }
            }
          });
        }

        window.addEventListener("beforeunload", () => {
          if (connection) connection.close();
        });

        startLiveReload();
      JAVASCRIPT
    end
  end
end
