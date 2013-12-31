require 'bundler/gem_tasks'
require 'rspec/core/rake_task'



task :default => [rspec]

desc 'run specifications'
RSpec::Core::RakeTask.new do |t|
  t.pattern = 'test/spec/*'
end

