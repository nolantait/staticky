# frozen_string_literal: true

threads 3

# Specifies the `port` that Puma will listen on to receive requests; default is
# 3000.
port 3000

# Only use a pidfile when requested
pidfile ENV["PIDFILE"] if ENV["PIDFILE"]
