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

You can find a working setup in `site_template` folder.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add staticky

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install staticky

## Usage

First you can use the CLI to generate a new template:

```
staticky new my_blog --url "https://example.com"
```

This will generate a new site at `./my_blog`, install your dependencies and run
`rspec` just to make sure everything got set up correctly.

You can append `--help` to any commands to see info:

```
staticky new --help
```

Which outputs:

```
Command:
  staticky new

Usage:
  staticky new PATH

Description:
  Create new site

Arguments:
  PATH                              # REQUIRED Relative path where the site will be generated

Options:
  --url=VALUE, -u VALUE             # Site URL, default: "https://example.com"
  --title=VALUE, -t VALUE           # Site title, default: "Example"
  --description=VALUE, -d VALUE     # Site description, default: "Example site"
  --twitter=VALUE, -t VALUE         # Twitter handle, default: ""
  --help, -h                        # Print this help
```

### Routing

Once your site is generated you can use the router to define how your content
maps to routes in `config/routes.rb`:

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

Each route takes a Phlex component (or any object that outputs a string from
`#call`). We can either pass the class for a default initialization (we just
call `.new`) or initialize it ourselves.

#### Match

This works in a similar way to your Rails routes. Match takes a path and
a component (either a class or an instance) that it will route to.

```ruby
match "404", to: Errors::NotFound
```

#### Root

Using `match` you can define a root path like:

```ruby
match "/", to: Pages::Home
```

For convenience you can shorten this using `root`:

```ruby
root to: Pages::Home
```

### Resources

Routes define your resources, which are objects that contain all the information
required to produce the static file that eventually outputs to your
`Staticky.build_path`.

Lets say we had a router defined like:

```ruby
Staticky.router.define do
  match "foo", to: Component
  match "bar", to: Component
end
```

Then we could view our resources:

```
(ruby) Staticky.resources
[#<Staticky::Resource:0x0000711525d82c18
  @component=#<Component:0x0000711525d74848>,
  @destination=#<Pathname:/your-site-folder/build>,
  @uri=#<URI::Generic /foo>,
  @url="foo">,
 #<Staticky::Resource:0x0000711525d82a88
  @component=#<Component:0x0000711525d74208>,
  @destination=#<Pathname:/your-site-folder/build>,
  @uri=#<URI::Generic /bar>,
  @url="bar">]
```

Each resource has a `#build` method that calls the Phlex component you provide
and passes in a `ViewContext` just like `ActionView` in Rails. But this context
is tailored towards your static site.

Currently it contains just two methods:

|Method|Description|
|------|-----------|
|`root?`|Whether or not this resource is for the root page|
|`current_path`|The path of the current resource being rendered|

These are useful for creating pages that hide or show content depending on which
path of the site we are building.

### Linking to your routes

First you need to include the view helpers somewhere in your component
hierarchy:

```ruby
class Component < Phlex::HTML
  include Staticky::Phlex::ViewHelpers
end
```

This will add `link_to` to all your components which uses the router to resolve
any URLs via their path.

Here is an example of what the `Posts::Show` component might look like. We are
using a [protos](https://github.com/inhouse-work/protos) component, but you can
use plain old Phlex components if you like.

```ruby
module Posts
  class Show < Component
    param :post, reader: false

    def around_template(&)
      render Layouts::Post.new(class: css[:layout], &)
    end

    def view_template
      # Links can be resolved to component classes if they are unique:
      link_to "Home", Pages::Home
      # They can also resolve via their url:
      link_to "Posts", "/posts"
      # Absolute links are resolved as is:
      link_to "Email", "mailto:email@example.com"

      render Posts::Header.new(@post)
      render Posts::Outline.new(@post, class: css[:outline])
      render Posts::Markdown.new(@post, class: css[:post])
      render Posts::Footer.new(@post)
    end

    private

    def theme
      {
        layout: "bg-background",
        outline: "border",
        post: "max-w-prose mx-auto"
      }
    end
  end
end
```

The advantage of using `link_to` over plain old `a` tags is that changes to your
routes will raise errors on invalidated links instead of silently
linking to invalid pages.

If your component is unique then you can link directly to them (if its not
unique then it will link to the last defined `match`):

```ruby
link_to("Some link", Pages::Home)
```

Otherwise you can link to the path itself:

```ruby
link_to("Some link", "/")
```

### Building your site

When you are developing your site you run `bin/dev` to start your development
server on [http://localhost:9292](http://localhost:9292).
This will automatically reload after a short period when you make changes.

Assets are handled by Vite by default, but you can have whatever build process
you like just by tweaking `Procfile.dev` and your `Rakefile`. You will also need
to create your own view helpers for linking your assets.

By default, to build your site you run the builder, usually inside a Rakefile:

```ruby
require "vite_ruby"

ViteRuby.install_tasks

desc "Precompile assets"
task :environment do
  require "./config/boot"
end

namespace :site do
  desc "Precompile assets"
  task build: :environment do
    Rake::Task["vite:build"].invoke
    Staticky.builder.call
  end
end
```

This will output your site to `./build` by default.

During building, each definition in the router is compiled and handed a special
view context which holds information about the resource being rendered such as
the `current_path`.

These are available in your Phlex components under `helpers` (if you are using
the site template). This matches what you might expect when using Phlex in
Rails with `phlex-rails`.

## Configuration

We can override the configuration according to the settings defined on the main
module:

```ruby
Staticky.configure do |config|
  config.env = :test
  config.build_path = Pathname.new("dist")
  config.root_path = Pathname(__dir__)
  config.logger = Logger.new($stdout)
  config.server_logger = Logger.new($stdout)
end
```

### Environment

You can define the environment of Staticky through its config.

```ruby
Staticky.configure do |config|
  config.env = :test
end
```

This lets you write environment specific code:

```ruby
if Staticky.env.test?
  # Do something test specific
end
```

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
