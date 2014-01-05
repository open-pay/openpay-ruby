 require 'rspec'
 require 'rspec/core/rake_task'

 task :default => [:spec]

 desc 'run specifications'
 RSpec::Core::RakeTask.new do |t|
   t.pattern = 'test/spec/*'
 end

