# frozen_string_literal: true

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
    Staticky::Builder.call
  end
end
