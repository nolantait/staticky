# frozen_string_literal: true

module Staticky
  class Builder
    # Publisher needs to have a different name vs the application monitor
    # https://github.com/dry-rb/dry-events/issues/6
    include Dry::Events::Publisher[:building]
    include Deps[:files, :router]

    register_event("started")
    register_event("finished")
    register_event("before_resource")
    register_event("after_resource")

    def self.call(...) = new(...).call

    def on(event_type, &) = subscribe(event_type, &)

    def call
      publish("started")
      copy_public_files
      build_site
      publish("finished")
    end

    private

    def build_site
      @router
        .resources
        .each do |resource|
          publish("before_resource", resource:)
          compile resource.build_path, resource.build
          publish("after_resource", resource:)
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
