# Staticky

Staticky is a static site builder for Ruby maximalists. I built this library
because I wanted something more scriptable than Bridgetown and Jekyll that had
first-class support for Phlex components.

[Phlex](https://phlex.fun) makes building component based frontends fun and
I wanted to extend the developer experience of something like Rails but focused
on static sites.

I am using this at https://taintedcoders.com. (soon)

- Hot reloading in development with Roda serving static files
- Docker deployment with NGINX

You can find a working setup in the `static-starter` repo:

https://github.com/nolantait/static-starter

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add staticky

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install staticky

## Usage

Use the router to define how your content maps to routes:

```ruby
Staticky.router.define do
  root to: Pages::Home
  match "404", to: Errors::NotFound
  match "500", to: Errors::ServiceError

  # Write your own logic to parse your data into components
  Site.posts.each_value do |model|
    match model.relative_url, to: Posts::Show.new(model)
  end
end
```

Each route takes a Phlex component. Here we are using
a [protos](https://github.com/inhouse-work/protos) component:

```ruby
module Posts
  class Show < Protos::Component
    param :post, reader: false

    def around_template(&)
      render Layouts::Post.new(class: css[:layout], &)
    end

    def view_template
      render Posts::Header.new(@post)
      render Posts::Outline.new(@post, class: css[:outline])
      render Posts::Markdown.new(@post, class: css[:post])
      render Posts::Footer.new(@post)
    end

    private

    def theme
      {
        layout: "mr-0 lg:mr-[--sidebar-width] md:ml-[--sidebar-width]",
        outline: %w[
          my-md
          md:fixed
          md:left-0
          md:top-[--navbar-height]
          md:pl-[--viewport-padding]
          md:w-[--sidebar-width]
        ],
        post: "prose mx-auto pb-lg"
      }
    end
  end
end
```

To build your site you run the builder, usually inside a Rakefile:

```ruby
# frozen_string_literal: true

desc "Precompile assets"
task :environment do
  require "./config/boot"
end

namespace :assets do
  desc "Precompile assets"
  task precompile: :environment do
    Staticky::Builder.call
  end
end
```

Doing it through `assets:precompile` makes it easily integrate with Vite without
much setup.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`bin/rspec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and the created tag, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nolantait/staticky.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
