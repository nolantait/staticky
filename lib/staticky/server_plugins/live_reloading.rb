# frozen_string_literal: true

module Staticky
  module ServerPlugins
    module LiveReloading
      def self.file_mtime(file)
        Staticky.files.exist?(file) ? file.mtime.to_i : 0
      end

      def self.setup_live_reload(app) # rubocop:disable Metrics
        sleep_interval = 0.5
        file_to_check = Staticky.build_path.join("index.html")
        errors_file = Staticky.build_path.join("errors.json")

        app.request.get "_staticky/live_reload" do # rubocop:disable Metrics/BlockLength
          last_seen_mtime = file_mtime(file_to_check)

          event_stream = proc do |stream|
            Thread.new do
              loop do
                current_mtime = file_mtime(file_to_check)
                should_reload = current_mtime > last_seen_mtime

                if should_reload
                  Staticky.logger.info(
                    "[LiveReload] Change detected in #{file_to_check}"
                  )

                  stream.write "data: reloaded!\n\n"
                  break
                elsif Staticky.files.exist?(errors_file)
                  stream.write "event: builderror\n" \
                               "data: #{errors_file.read.to_json}\n\n"
                else
                  stream.write "data: #{current_mtime}\n\n"
                end

                sleep sleep_interval
              rescue Errno::EPIPE # User refreshed the page
                break
              end
            ensure
              stream.close
            end
          end

          app.request.halt [
            200,
            {
              "Content-Type" => "text/event-stream",
              "cache-control" => "no-cache"
            },
            event_stream
          ]
        end
      end
    end
  end
end
