# Static starter

This is a minimal static site builder with [phlex](https://phlex.fun) and
[protos](https://github.com/inhouse-work/protos) component library.

Everything is ruby, there is no html or erb. It outputs a static site to the
`build/` folder.

## Usage

```
git clone https://github.com/nolantait/static-starter
cd static-starter
bin/setup
bin/dev
```

## Building

When your site it built with `bin/rake site:build` it will output everything
defined in your `config/routes` as well as anything in `public/` into `build/`.
You can then serve these using something like nginx.

## Views

Views are defined in `app/pages` and `app/layouts`. `app/components` are for
your general components that many pages or layouts might use.

## Javascript

All javascript and images are handled via [Vite](https://vite-ruby.netlify.app/)

## Router

Your routes are defined in `config/routes.rb` and determine the output for your
site. Everything gets built into the `build/` folder by default.

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

    match file.gsub("content/", "").gsub(".md", ""),
          to: Pages::Post.new(
            parsed.content,
            front_matter: parsed.front_matter.transform_keys(&:to_sym)
          )
  end
end
```

The router is your definition for how to build your static site.

## Deployment

Deployment is done through a simple Dockerfile. This setup is optimized for
deploying onto Dokku servers.
