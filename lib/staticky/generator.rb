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

    def call(output_dir, **kwargs)
      view_context = ViewContext.new(**kwargs)
      output_dir = Pathname.new(output_dir).expand_path

      Pathname.glob(@path.join("**/*")).each do |file|
        next if file.directory?

        output_path = file.relative_path_from(@path)

        destination, output = if file.extname == ".erb"
          template = Tilt.new(file)
          content = template.render(view_context)
          output_path = output_path.sub_ext("")
          output_path = output_path.sub_ext(".rb") if output_path.extname.empty?
          destination = output_dir.join(output_path)
          [destination, content]
        else
          destination = output_path.join(file.relative_path_from(@path))
          [destination, file.read]
        end

        files.write(destination, output)
      end
    end
  end
end
