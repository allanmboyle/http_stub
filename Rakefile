require 'bundler'
require 'rspec/core/rake_task'
require File.expand_path('../lib/http/stub/rake_task', __FILE__)

directory "coverage"

Bundler::GemHelper.install_tasks

desc "Removed generated artefacts"
task :clobber do
  rm_rf "coverage"
  rm Dir.glob("**/coverage.data"), force: true
  puts "Clobbered"
end

desc "Complexity analysis"
task :metrics do
  print " Complexity Metrics ".center(80, "*") + "\n"
  print `find lib -name \\*.rb | xargs flog --continue`
  print "*" * 80+ "\n"
end

desc "Exercises specifications"
::RSpec::Core::RakeTask.new(:spec)

desc "Exercises specifications with coverage analysis"
task :coverage => :spec do
  require 'cover_me'
  CoverMe.complete!
end

task :validate do
  print " Travis CI Validation ".center(80, "*") + "\n"
  result = `travis-lint #{File.expand_path('../travis.yml', __FILE__)}`
  puts result
  print "*" * 80+ "\n"
  raise "Travis CI validation failed" unless result =~ /^Hooray/
end

Http::Stub::RakeTask.new(:sample, 8001)

task :default => [:clobber, :metrics, :coverage]

task :pre_commit => [:default, :validate]
