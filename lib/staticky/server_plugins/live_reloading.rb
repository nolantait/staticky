# frozen_string_literal: true

module Staticky
  module ServerPlugins
    module LiveReloading
      def self.setup_live_reload(app) # rubocop:disable Metrics
        sleep_interval = 0.5
        file_to_check = Staticky.build_path.join("index.html")
        errors_file = Staticky.build_path.join("errors.json")

        app.request.get "_staticky/live_reload" do # rubocop:disable Metrics/BlockLength
          @_mod = if Staticky.files.exist?(file_to_check)
            file_to_check.mtime.to_i
          else
            0
          end

          event_stream = proc do |stream|
            Thread.new do
              loop do
                new_mod = if Staticky.files.exist?(file_to_check)
                  file_to_check.mtime.to_i
                else
                  0
                end

                if @_mod < new_mod
                  stream.write "data: reloaded!\n\n"
                  break
                elsif Staticky.files.exist?(errors_file)
                  stream.write "event: builderror\n" \
                               "data: #{errors_file.read.to_json}\n\n"
                else
                  stream.write "data: #{new_mod}\n\n"
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
