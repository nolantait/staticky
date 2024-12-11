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
      output_dir = Pathname(output_dir).expand_path

      Pathname.glob(@path.join("**/*"), File::FNM_DOTMATCH).each do |input_path|
        relative_path = input_path.relative_path_from(@path)
        output_path = output_dir.join(relative_path)
        build_file(input_path:, output_path:, view_context:)
      end
    end

    private

    def build_file(input_path:, output_path:, view_context:)
      return if input_path.directory?

      # This handles files like:
      # - index.html.erb -> index.html
      # - site.erb -> site.rb
      # - .ruby-version.erb -> .ruby-version
      output_path = output_path.then do |filepath|
        next filepath unless filepath.extname == ".erb"

        # Replace the .erb with nothing. Skip if its not a ruby file
        # site.erb -> site
        filepath = filepath.sub_ext("")
        next filepath unless filepath.extname.empty?
        next filepath if dotfile?(filepath)

        filepath.sub_ext(".rb")
      end

      build_template(input_path:, output_path:, view_context:)
    end

    def build_template(input_path:, output_path:, view_context:)
      files.write(output_path, render_template(input_path, view_context))
    end

    def render_template(file, view_context)
      return file.read unless file.extname == ".erb"

      Tilt::ERBTemplate.new(file).render(view_context)
    end

    def dotfile?(path)
      path.basename.to_s.start_with?(".")
    end
  end
end
