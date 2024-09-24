# Static starter

This is a minimal static site builder with [phlex](https://phlex.fun) and
[protos](https://github.com/inhouse-work/protos) component library.

[Vite](https://vite-ruby.netlify.app/) handles your javascript and your
assets by default and hooks into the build command defined in your `Rakefile`

Your development server runs with `bin/dev`

Everything is ruby, there is no html or erb. It outputs a static site to the
`./build` folder by default, but that can be configured.

## Usage

First we need to install `staticky` if you have not already:

```
gem install staticky
```

Then we can use the CLI to generate a new template:

```
staticky new my_blog
```

Finally cd into your new site and run the development server:

```
cd my_blog
bin/dev
```

Your site should not be accessible at http://localhost:9292

## Building

During development `filewatcher` watches your files and rebuilds the site when they
change by running `bin/rake site:build`. These files are served by a Roda app.

In production you simply output the files to a folder and serve them statically
on your website. We have included a `Dockerfile` with a working nginx setup that
can be tweaked however you like.

Building takes all the definitions inside your `config/routes` and outputs
static files to `./build` or wherever you have configured it.

## Development and hot reloading

By default your site will use `puma` to run a `roda` server that serves the
files inside your `Staticky.build_path` (`./build` by default).

You can access your site at:

```
http://localhost:3000
```

You can change these settings inside your `Procfile.dev` which starts the
processes required for development.

When your site triggers a rebuild and you are connected to the page. The vite
server will trigger a page reload after 500ms.

If this is too fast and you find yourself having to refresh the page yourself
you can tweak this inside your `vite.config.ts`.

## Views

Views are defined in `app/views`. They should be phlex components and you can
choose how to render them inside your router.

## Javascript

All javascript and images are handled via [Vite](https://vite-ruby.netlify.app/)

## Router

Your routes are defined in `config/routes.rb` and determine the output for your
site. Everything gets built into the `./build` folder by default.

Here is an example of loading content for a blog:

```ruby
# frozen_string_literal: true

require "date"
require "front_matter_parser"

loader = FrontMatterParser::Loader::Yaml.new(allowlist_classes: [Date])

Staticky.router.define do
  root to: Pages::Home.new

  # Link directly to components or their classes in your routes
  match "404", to: Errors::NotFound.new
  match "500", to: Errors::ServiceError.new(class: "bg-red-500")

  # Write your own custom logic for parsing your markdown
  Dir["content/**/*.md"].each do |file|
    parsed = FrontMatterParser::Parser.parse_file(file, loader:)
    basenames = file.gsub("content/", "").gsub(".md", "")
    front_matter = parsed.front_matter.transform_keys(&:to_sym)

    basename.each do |path|
      match path, to: Pages::Post.new(parsed.content, front_matter:)
    end
  end
end
```

The router is your definition for how to build your static site.

## Deployment

Deployment is done through a simple Dockerfile. This setup is optimized for
deploying onto Dokku servers.

By default Dokku expects the app to be exposed on port 5000 which we do through
our Dockerfile. Dokku will scan the Dockerfile for an `EXPOSE` directive and
automatically setup the port routing for you.
