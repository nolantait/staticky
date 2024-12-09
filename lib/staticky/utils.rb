# frozen_string_literal: true

module Staticky
  module Utils
    module_function

    def live_reload_js(base_path) # rubocop:disable Metrics/MethodLength
      return "" unless Staticky.env.development?

      path = File.join(base_path, "/_staticky/live_reload")

      <<~JAVASCRIPT
        let lastmod = 0
        let reconnectAttempts = 0

        function statickyReload() {
          if (window.Turbo) {
            Turbo.visit(window.location)
          } else {
            location.reload()
          }
        }

        function startLiveReload() {
          const connection = new EventSource("#{path}")

          connection.addEventListener("message", event => {
            reconnectAttempts = 0

            if (event.data == "reloaded!") {
              statickyReload()
            } else {
              const newmod = Number(event.data)

              if (lastmod < newmod) {
                statickyReload()
                lastmod = newmod
              }
            }
          })

          connection.addEventListener("error", () => {
            if (connection.readyState === 2) {
              // reconnect with new object
              connection.close()
              reconnectAttempts++
              if (reconnectAttempts < 25) {
                console.warn("Live reload: attempting to reconnect in 3 seconds...")
                setTimeout(() => startLiveReload(), 3000)
              } else {
                console.error(
                  "Too many live reload connections failed. Refresh the page to try again."
                )
              }
            }
          })
        }

        startLiveReload()
      JAVASCRIPT
    end
  end
end
