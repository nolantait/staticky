# frozen_string_literal: true

module ViteHelpers
  def vite_client_tag
    src = vite_manifest.vite_client_src || "/vite-dev/@vite/client"
    script(src:, type: :module)
  end

  def vite_javascript_tag(
    *names,
    type: :module,
    asset_type: :javascript,
    crossorigin: :anonymous,
    **options
  )
    entries = vite_manifest.resolve_entries(*names, type: asset_type)
    entries.fetch(:scripts).each do |src|
      script(
        src:,
        type:,
        crossorigin:,
        extname: :js,
        **options
      )
    end
    entries.fetch(:stylesheets).each do |href|
      link(href:, rel: :stylesheet, type: "text/css")
    end
  end

  def vite_manifest
    ViteRuby.instance.manifest
  end

  def vite_asset_path(name, **)
    vite_manifest.path_for(name, **)
  end
end
