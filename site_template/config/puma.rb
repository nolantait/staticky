# frozen_string_literal: true

# Run in single threaded mode
threads 0, 1

# Specifies the `port` that Puma will listen on to receive requests; default is
# 3000.
port 3000

# Only use a pidfile when requested
pidfile ENV["PIDFILE"] if ENV["PIDFILE"]
