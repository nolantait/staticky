# frozen_string_literal: true

module Staticky
  class Builder
    def self.call(...) = new(...).call

    def initialize(
      files: Staticky.files,
      output: Staticky.build_path,
      root: Staticky.root_path,
      router: Staticky.router
    )
      @files = files
      @root_path = Pathname.new(root)
      @output_path = Pathname.new(output)
      @router = router
    end

    def call
      copy_public_files
      build_site
    end

    private

    def build_site
      @router
        .resources
        .each do |resource|
          compile(
            output_path(resource.filepath),
            resource.component.call(view_context: nil)
          )
        end
    end

    def copy_public_files
      public_folder = @root_path.join("public")
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
      @root_path.join("public", path)
    end

    def output_path(path)
      @output_path.join(path)
    end
  end
end
