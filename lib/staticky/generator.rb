# frozen_string_literal: true

module Staticky
  class Generator
    include Deps[:files]

    class ViewContext
      attr_reader :title, :description, :twitter, :url

      def initialize(url:, title: "", description: "", twitter: "")
        @title = title
        @description = description
        @twitter = twitter
        @url = URI(url)

        raise ArgumentError, "Must be a full url: #{@url}" unless @url.host
      end
    end

    def initialize(**kwargs)
      super
      @path = GEM_ROOT.join("site_template")
    end

    def call(output_dir, **)
      view_context = ViewContext.new(**)
      output_dir = Pathname.new(output_dir).expand_path

      Pathname.glob(@path.join("**/*"), File::FNM_DOTMATCH).each do |file|
        build_file(file:, output_dir:, view_context:)
      end
    end

    private

    def build_file(file:, output_dir:, view_context:)
      return if file.directory?

      relative_path = file.relative_path_from(@path)
      target = output_dir.join(relative_path)

      # This handles files like:
      # - index.html.erb -> index.html
      # - site.erb -> site.rb
      if target.extname == ".erb"
        target = target.sub_ext("")
        target = target.sub_ext(".rb") if target.extname == ""
      end

      build_template(file:, target:, view_context:)
    end

    def build_template(file:, target:, view_context:)
      files.write(target, render_template(file, view_context))
    end

    def render_template(file, view_context)
      return file.read unless file.extname == ".erb"

      Tilt::ERBTemplate.new(file).render(view_context)
    end
  end
end
