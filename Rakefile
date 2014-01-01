$:.unshift File.expand_path 'lib/openpay'
$:.unshift File.expand_path 'lib'
$:.unshift File.expand_path 'openpay'

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

task :default => [:spec]

desc 'run specifications'
RSpec::Core::RakeTask.new do |t|
  t.pattern = 'test/spec/*'
end

