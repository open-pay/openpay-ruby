require 'bundler/gem_tasks'
require 'rspec/core/rake_task'


task :default => [:spec]

desc 'run specifications'
RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = '-I \'lib\''

  t.pattern = 'test/spec/*'
end

