# frozen_string_literal: true

module Staticky
  class Builder
    include Dry::Events::Publisher[:builder]
    include Deps[:files, :router]

    register_event("build.started")
    register_event("build.finished")

    def self.call(...) = new(...).call

    def call
      publish("build.started")
      copy_public_files
      build_site
      publish("build.finished")
    end

    private

    def build_site
      @router
        .resources
        .each do |resource|
          compile output_path(resource.filepath), resource.build
        end
    end

    def copy_public_files
      public_folder = Staticky.root_path.join("public")
      return unless @files.exist? public_folder

      @files.children(public_folder).each do |file|
        # file => "favicon.ico"
        copy(public_path(file), output_path(file))
      end
    end

    def compile(destination, content)
      @files.write destination, content
    end

    def copy(source, destination)
      @files.cp source, destination
    end

    def public_path(path)
      Staticky.root_path.join("public", path)
    end

    def output_path(path)
      Staticky.build_path.join(path)
    end
  end
end
