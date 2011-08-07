require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "waterpark"
  gem.homepage = "http://github.com/bdewitt/waterpark"
  gem.license = "MIT"
  gem.summary = %Q{ WaterPark manages multiple SocketPools }
  gem.description = %Q{ Why a pool manager?  New cache providers have included the ability to add cache servers on-the-fly, 
                        I needed a socketpooling manager to dynamically add and change the available pools, can be used for
                        many other things, but the original motivation was topology aware socketpooling for Infinispan }
  gem.email = "brandon+waterpark@myjibe.com"
  gem.authors = ["Brandon Dewitt"]
  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)
  gem.add_runtime_dependency 'socketpool'
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "waterpark #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
