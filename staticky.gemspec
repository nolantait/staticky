# frozen_string_literal: true

require_relative "lib/staticky/version"

Gem::Specification.new do |spec|
  spec.name = "staticky"
  spec.version = Staticky::VERSION
  spec.authors = ["Nolan J Tait"]
  spec.email = ["nolanjtait@gmail.com"]

  spec.summary = "Static site"
  spec.description = spec.summary
  spec.homepage = "https://github.com/nolantait/staticky"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.3"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added
  # into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(
    %w[git ls-files -z],
    chdir: __dir__,
    err: IO::NULL
  ) do |ls|
    ls.readlines(
      "\x0",
      chomp: true
    ).reject do |f|
      (f == gemspec) ||
        f.start_with?(
          *%w[
            bin/
            test/
            spec/
            features/
            .git
            appveyor
            Gemfile
          ]
        )
    end
  end
  spec.bindir = "bin"
  spec.executables = ["staticky"]
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "dry-cli", "~> 1"
  spec.add_dependency "dry-configurable", "~> 1"
  spec.add_dependency "dry-container", "~> 0.11"
  spec.add_dependency "dry-events", "~> 1"
  spec.add_dependency "dry-inflector", "~> 1"
  spec.add_dependency "dry-logger", "~> 1"
  spec.add_dependency "dry-monitor", "~> 1"
  spec.add_dependency "dry-system", "~> 1"
  spec.add_dependency "phlex", "~> 2"
  spec.add_dependency "roda", "~> 3"
  spec.add_dependency "staticky-files", "~> 0.1"
  spec.add_dependency "tilt", "~> 2"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata["rubygems_mfa_required"] = "true"
end
