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

          system(
            "cd #{path} && bin/setup",
            chdir: path
          ) || abort("install failed")
        end
      end
    end
  end
end
