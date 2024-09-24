# frozen_string_literal: true

module Staticky
  module CLI
    module Commands
      class Generate < Dry::CLI::Command
        desc "Create new site"

        argument :path,
                 required: true,
                 desc: "Relative path where the site will be generated"

        option :url,
               default: "https://example.com",
               desc: "Site URL",
               aliases: ["-u"]
        option :title,
               default: "Example",
               desc: "Site title",
               aliases: ["-t"]
        option :description,
               default: "Example site",
               desc: "Site description",
               aliases: ["-d"]
        option :twitter,
               default: "",
               desc: "Twitter handle",
               aliases: ["-t"]

        def call(path:, **)
          path = Pathname.new(path).expand_path

          Staticky.generator.call(path, **)

          Dir.chdir(path) do
            system("cd #{path}")
            system("chmod +x bin/*")
            bundle_command("install")
            bundle_command("exec bin/setup")
          end
        end

        def bundle_command(command, env = {})
          puts "bundle #{command}"

          # We are going to shell out rather than invoking Bundler::CLI.new(command)
          # because `rails new` loads the Thor gem and on the other hand bundler uses
          # its own vendored Thor, which could be a different version. Running both
          # things in the same process is a recipe for a night with paracetamol.
          #
          # Thanks to James Tucker for the Gem tricks involved in this call.
          _bundle_command = Gem.bin_path("bundler", "bundle")

          require "bundler"
          Bundler.with_original_env do
            exec_bundle_command(_bundle_command, command, env)
          end
        end

        def exec_bundle_command(bundle_command, command, env)
          full_command = %Q["#{Gem.ruby}" "#{bundle_command}" #{command}]
          system(env, full_command)
        end
      end
    end
  end
end
